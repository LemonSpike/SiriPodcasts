/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 This file implements the resolution of intent parameters and the handling of intents
 */
import os.log
import Intents
import IntentsUI
import MediaPlayer

class IntentHandler: INExtension, INPlayMediaIntentHandling {
  
  //TODO: Complete this function when Intent is playable.
  func makeArtwork(_ urlString: String?) -> INImage? {
    guard let urlString = urlString else {
      return nil
    }
    
    let scaleFactor = UIScreen.main.scale
    let imageSize = INImage.imageSize(for: INPlayMediaIntentResponse(code: .unspecified, userActivity: nil))
    let resolvedUrlString = urlString.replacingOccurrences(
      of: "{w}x{h}", with: String(format: "%.0fx%.0f", imageSize.width * scaleFactor, imageSize.height * scaleFactor))
    
    guard let url = URL(string: resolvedUrlString) else {
      return nil
    }
    
    return INImage(url: url)
  }
  
  func resolveLocalpodcastFromSearch(_ mediaSearch: INMediaSearch, completion: ([INMediaItem]?) -> Void) {
    // Look up podcast in the local library.
    guard let podcastName = mediaSearch.mediaName,
          let podcast = MediaPlayerUtilities.searchForPodcastInLocalLibrary(byName: podcastName) else {
      completion(nil)
      return
    }
    
    // Construct the media item with an identifier indicating this is a local identifier.
    let persistentID = "\(MediaPlayerUtilities.LocalLibraryIdentifierPrefix)\(podcast.persistentID)"
    let mediaItem = INMediaItem(identifier: persistentID, title: podcast.podcastTitle, type: .podcastShow, artwork: nil)
    
    completion([mediaItem])
  }
  
  func  resolveMediaItems(for optionalMediaSearch: INMediaSearch?, completion: @escaping ([INMediaItem]?) -> Void) {
      guard let mediaSearch = optionalMediaSearch else {
        completion(nil)
        return
      }
      
      // Not sure how to develop my own custom logic to have a highly robust search from Siri transcription in case this is the issue as I can't use breakpoints. :(
      switch mediaSearch.mediaType {
        case .podcastShow:
          self.resolveLocalpodcastFromSearch(mediaSearch, completion: completion)
        default:
          completion(nil)
      }
  }
  
  /*
   * INPlayMediaIntent methods
   */
  
  func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
    resolveMediaItems(for: intent.mediaSearch) { optionalMediaItems in
      guard let mediaItems = optionalMediaItems else {
        completion([INPlayMediaMediaItemResolutionResult.unsupported()])
        return
      }
      completion(INPlayMediaMediaItemResolutionResult.successes(with: mediaItems))
    }
  }
  
  // The handler for INPlayMediaIntent returns the .handleInApp response code, so that the main app can be background
  // launched and begin playback. The extension is short-lived, and if playback was begun in the extension, it could
  // abruptly end when the extension is terminated by the system.
  func handle(intent: INPlayMediaIntent, completion: (INPlayMediaIntentResponse) -> Void) {
    completion(INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil))
  }
}
