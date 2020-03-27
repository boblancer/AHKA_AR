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
    
    let defaults = UserDefaults.standard
    var player: AVPlayer?
    var layer: AVPlayerLayer?
    var timer: Timer? = nil
    var second = 0
    
    var videoIndex = 0
    
    @IBOutlet weak var skipButtonBlack: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var skipButtonYellow: UIButton!
    @IBOutlet weak var realStartButton: UIButton!
    
    
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
            video()
            defaults.set(true, forKey: "First Launch")
        }
    }
    
    func video(){
        let videoString:String? = Bundle.main.path(forResource: "INTRO_final2", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        self.player = AVPlayer(url: videoUrl)
        layer?.removeFromSuperlayer()
        layer = AVPlayerLayer(player: player)
        layer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer?.frame = videoView.bounds
        videoView.layer.addSublayer(layer!)
        self.player?.play()
        DispatchQueue.main.async {
            if self.timer == nil{
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateSkipButton), userInfo: nil, repeats: true)
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        switch videoIndex {
        case 0:
            player?.seek(to: CMTime.init(seconds: 12, preferredTimescale: 1))
        case 1:
            player?.seek(to: CMTime.init(seconds: 29, preferredTimescale: 1))
        case 2:
            player?.seek(to: CMTime.init(seconds: 36.19, preferredTimescale: 1))
            player?.pause()
            startButton.isHidden = false
            realStartButton.isHidden = false
        default:
            break
        }
                                
    }

    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.performSegue(withIdentifier: "videoToMap", sender: self)
    }
    
    @objc func updateSkipButton() {
        switch Int((player?.currentTime().seconds)!) {
            case 0...2:
                skipButtonYellow.isHidden = true
                skipButtonBlack.isHidden = false
            case 3...11:
                skipButtonYellow.isHidden = true
                skipButtonBlack.isHidden = true
            case 12...14:
                videoIndex = 1
                skipButtonYellow.isHidden = false
                skipButtonBlack.isHidden = true
            case 15...28:
                skipButtonYellow.isHidden = true
                skipButtonBlack.isHidden = true
            case 29...31:
                videoIndex = 2
                skipButtonYellow.isHidden = true
                skipButtonBlack.isHidden = false
            case 32...34:
                skipButtonYellow.isHidden = true
                skipButtonBlack.isHidden = true
            case 35...37:
                skipButtonBlack.isHidden = true
                skipButtonYellow.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.19) {
                    if self.timer != nil{
                        self.timer!.invalidate()
                        self.timer = nil
                    }
                    self.player?.pause()
                    self.startButton.isHidden = false
                    self.realStartButton.isHidden = false

                    
                    if self.timer == nil{
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setupStartButton), userInfo: nil, repeats: true)
                    }
                }
            default:
                if self.timer != nil{
                    timer?.invalidate()
                }
            }
    }
    
  
        
    
    
    @objc func setupStartButton(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 1) {
                self.startButton.transform = CGAffineTransform.identity
            }
        }
        second += 1
        if second == 10{
            if timer != nil {
                timer?.invalidate()
                startButton.isHidden = true
                player?.play()
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if timer != nil {
            timer?.invalidate()
            startButton.isHidden = true
            player?.play()
        }
    }
 
}
    

    

