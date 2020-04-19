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
    var lastPlayed: String?
    func playSound(resourceName: String){
        let soundPath:String? = Bundle.main.path(forResource: "sound" + resourceName, ofType: "mp3")
        self.lastPlayed = soundPath
        print("sound" + resourceName)
        guard let unwrappedSoundPath = soundPath else {
            print("Sound path error")
            return
        }

        let url = URL(fileURLWithPath: unwrappedSoundPath)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient  , mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    func getDuration() -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: lastPlayed!))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    func invalidate(){
        if player != nil{
            player?.pause()
            player = nil
        }
    }
}
