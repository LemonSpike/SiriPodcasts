/*
See LICENSE folder for this sample’s licensing information.

Abstract:
This file implements a few utilities for interacting with MediaPlayer
*/
import Foundation
import MediaPlayer

class MediaPlayerUtilities {
    public static let LocalLibraryIdentifierPrefix = "library://"

    private class func searchForPodcastInLocalLibrary(withPredicate predicate: MPMediaPropertyPredicate) -> MPMediaItem? {
        let mediaQuery = MPMediaQuery.podcasts()
        mediaQuery.addFilterPredicate(predicate)

      return mediaQuery.items?.first
    }

    class func searchForPodcastInLocalLibrary(byName podcastName: String) -> MPMediaItem? {
        let predicate = MPMediaPropertyPredicate(value: podcastName, forProperty: MPMediaItemPropertyPodcastTitle)
        return searchForPodcastInLocalLibrary(withPredicate: predicate)
    }

    class func searchForPodcastInLocalLibrary(byPersistentID persistentID: UInt64) -> MPMediaItem? {
        let predicate = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID)
        return searchForPodcastInLocalLibrary(withPredicate: predicate)
    }
}
