//
//  MusicGenModel.swift
//  CleanArchitecture
//
//  Created by Temur on 12/09/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
import Replicate
enum MusicGen: Predictable {
    struct Input: Codable {
        let prompt: String
        var duration: Int = 3
    }
    
    typealias Output = [URL]
    
    static var versionID: Model.Version.ID = "671ac645ce5e552cc63a54a2bbff63fcf798043055d2dac5fc9e36a837eedcfb"
    
    static var modelID: Model.ID = "meta/musicgen/stereo-large"
}
