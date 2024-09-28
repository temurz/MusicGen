//
//  SoundManager.swift
//  CleanArchitecture
//
//  Created by Temur on 12/09/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import AVFoundation
class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(url: URL){
        
        self.audioPlayer = AVPlayer(url: url)
        
    }
}
