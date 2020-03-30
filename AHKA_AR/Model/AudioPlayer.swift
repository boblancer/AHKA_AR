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
        let soundPath:String? = Bundle.main.path(forResource: "sound" + resourceName, ofType: "mp3")
        print("sound" + resourceName)
        guard let unwrappedSoundPath = soundPath else {
            print("Sound path error")
            return
        }

        let url = URL(fileURLWithPath: unwrappedSoundPath)
        
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
