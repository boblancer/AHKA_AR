//
//  VideoController.swift
//  AHKA_AR
//
//  Created by Kanokporn Wongwaitayakul on 21/3/2563 BE.
//  Copyright © 2563 boblancer. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoController: UIViewController{
    
    let videoListName: [String] = ["media.io_culture_1", "media.io_culture_1", "media.io_culture_1"]
    let defaults = UserDefaults.standard
    var player: AVPlayer?
    var videoIndex = 0

    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if defaults.bool(forKey: "First Launch") == true{
            self.performSegue(withIdentifier: "videoToMap", sender: self)
            defaults.set(true, forKey: "First Launch")
        }
        else{
            setupVideo(videoListName[videoIndex])
            defaults.set(true, forKey: "First Launch")
        }
    }
    
    func setupVideo(_ videoName: String){
        let videoString:String? = Bundle.main.path(forResource: videoName, ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        self.player = AVPlayer(url: videoUrl)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.frame = videoView.bounds
        videoView.layer.addSublayer(layer)
        self.player?.play()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if videoIndex == 2{
            player?.pause()
            self.performSegue(withIdentifier: "videoToMap", sender: self)
        }
        else{
            videoIndex += 1
            player?.pause()
            setupVideo(videoListName[videoIndex])
        }
    }

    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        if videoIndex == 2{
            self.performSegue(withIdentifier: "videoToMap", sender: self)
        }
        else{
            videoIndex += 1
            setupVideo(videoListName[videoIndex])
        }
    }
    
    
}
