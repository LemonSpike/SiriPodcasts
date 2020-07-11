//
//  AVPlayer_Extension.swift
//  ControlAudio
//
//  Created by Pranav Kasetti on 09/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
