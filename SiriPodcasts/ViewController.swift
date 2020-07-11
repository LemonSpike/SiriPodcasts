/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 This file implements methods for managing updating the UI state via MediaPlayer notifications
 */
import UIKit
import MediaPlayer

class ViewController: UIViewController {
  
  @IBOutlet private weak var playPauseButton: UIButton?
  @IBOutlet private weak var skipBackwardsButton: UIButton?
  @IBOutlet private weak var skipForwardsButton: UIButton?
  @IBOutlet private weak var songName: UILabel?
  @IBOutlet private weak var albumAndArtistName: UILabel?
  @IBOutlet private weak var albumArt: UIImageView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction private func playPause(sender: UIButton) {
    
    let player = (UIApplication.shared.delegate as? AppDelegate)?.player
    
    if player?.isPlaying == true {
      player?.pause()
    } else {
      player?.play()
    }
  }
}

