/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 This file implements the AppDelegate callback methods for the intent handling via background app launch
 */
import os.log
import UIKit
import Intents
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var player: AVPlayer?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Set our podcast title in AppIntentVocabulary.plist so we get the proper Siri intent.
    // In your app, you'll want to make this dynamically tuned to a user's podcast titles.
    let vocabulary = INVocabulary.shared()
    let podcastNames = NSOrderedSet(objects: "The Talk Show with John Gruber")
    vocabulary.setVocabularyStrings(podcastNames, of: .mediaShowTitle)
    
    INPreferences.requestSiriAuthorization { (status) in
      print(status)
    }
    
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func handlePlayMediaIntent(_ intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
    // Extract the first media item from the intent's media items (these will have been resolved in the extension).
    guard let mediaItem = intent.mediaItems?.first, let identifier = mediaItem.identifier else {
      return
    }
    
    // Check if this media item is a podcast and if it's identifier has the local library prefix.
    if mediaItem.type == .podcastShow, let range = identifier.range(of: MediaPlayerUtilities.LocalLibraryIdentifierPrefix) {
      // Extract the persistentID for the local podcast and look it up in the library.
      guard let persistentID = UInt64(identifier[range.upperBound...]),
            let podcast = MediaPlayerUtilities.searchForPodcastInLocalLibrary(byPersistentID: persistentID) else {
        return
      }
      
      guard let podcastURL = podcast.assetURL else {
        return
      }
      
      // Set the player queue to the local podcast.
      player = AVPlayer(url: podcastURL)
      
      DispatchQueue.main.async {
        self.player?.play()
      }
    } else {
      print("ERROR with finding in library.")
    }
    
    
    completion(INPlayMediaIntentResponse(code: .success, userActivity: nil))
  }
  
  // This method is called when the application is background launched in response to the extension returning .handleInApp.
  func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
    guard let playMediaIntent = intent as? INPlayMediaIntent else {
      completionHandler(INPlayMediaIntentResponse(code: .failure, userActivity: nil))
      return
    }
    handlePlayMediaIntent(playMediaIntent, completion: completionHandler)
  }
}

