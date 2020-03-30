//
//  AudioPlayer.swift
//  AHKA_AR
//
//  Created by sartsawatj on 3/30/20.
//  Copyright © 2020 boblancer. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer{
    var player: AVAudioPlayer?
    func playSound(resourceName: String){
        let filePath = Bundle.main.path(forResource: resourceName, ofType: "mp3")
        let url = URL(fileURLWithPath: filePath!)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback  , mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
}
