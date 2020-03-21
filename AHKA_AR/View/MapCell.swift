//
//  MapCell.swift
//  AHKA_AR
//
//  Created by Kanokporn Wongwaitayakul on 24/2/2563 BE.
//  Copyright © 2563 boblancer. All rights reserved.
//

import UIKit
import Foundation

protocol PinDelegate {
    func pinIsPressed(_ mapCell: MapCell, _ imageTitle : String)
}

class MapCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var delegate: PinDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var cuturalCenter: UIButton!
    @IBOutlet weak var saoChingcha: UIButton!
    @IBOutlet weak var visitorCenter: UIButton!
    @IBOutlet weak var ghostDoor: UIButton!
    @IBOutlet weak var noName1: UIButton!
    @IBOutlet weak var coffeeRoasting: UIButton!
    @IBOutlet weak var holyWell: UIButton!
    @IBOutlet weak var voodooHub: UIButton!
    @IBOutlet weak var chiefHub: UIButton!
    @IBOutlet weak var coffee: UIButton!
    @IBOutlet weak var skywalk: UIButton!
    @IBOutlet weak var noName2: UIButton!
    

    
    // resize bottom center
    @IBOutlet weak var text1: UIButton!
    @IBOutlet weak var text2: UIButton!
    @IBOutlet weak var saoChingchaText: UIButton!
    @IBOutlet weak var cuturalCenterText: UIButton!
    @IBOutlet weak var ghostDoorText: UIButton!
    @IBOutlet weak var coffeeText: UIButton!
    @IBOutlet weak var voodooHubText: UIButton!
    @IBOutlet weak var chiefHubText: UIButton!
    @IBOutlet weak var holyWellText: UIButton!
    @IBOutlet weak var coffeeRoastingText: UIButton!
    @IBOutlet weak var skywalkText: UIButton!
    
    // resize left center
    @IBOutlet weak var text3: UIButton!
    @IBOutlet weak var text4: UIButton!
    @IBOutlet weak var visitorCenterText: UIButton!
    
    var textList: [UIButton] = []
    var textList2: [UIButton] = []
    var pinList: [UIButton] = []
    var textPosition: [UIButton: [CGFloat]] = [:]
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        initPin()
    }
    
    func initPin(){
        pinList = [cuturalCenter, saoChingcha, visitorCenter, ghostDoor, noName1, coffeeRoasting, holyWell, voodooHub, chiefHub, coffee, skywalk, noName2]
        
        textList = [text1, text2, saoChingchaText, cuturalCenterText, ghostDoorText, coffeeText, voodooHubText, chiefHubText, holyWellText, coffeeRoastingText, visitorCenterText]
        
        textList2 = [text3, text4, skywalkText]
        
    }
    
    @IBAction func pinPressed(_ sender: UIButton) {
        let imageTitle = sender.accessibilityIdentifier! + "Info"
        self.delegate?.pinIsPressed(self, imageTitle)
        
        
        let width = sender.frame.width * 0.8333333
        let height = sender.frame.height * 0.8333333
        let x = sender.frame.origin.x + (width * 0.1)
        let y = sender.frame.origin.y + (height * 0.2)
        sender.frame = CGRect(x: x , y: y, width: width, height: height)

    }
    @IBAction func pinIsPressing(_ sender: UIButton) {
        let difX = sender.frame.width * 0.1
        let difY = sender.frame.height * 0.2
        let x = sender.frame.origin.x - difX
        let y = sender.frame.origin.y - difY
        let width = sender.frame.width * 1.2
        let height = sender.frame.height * 1.2
        sender.frame = CGRect(x: x , y: y, width: width, height: height)
    }
    

    @IBAction func pinIsDragedExit(_ sender: UIButton) {
        let width = sender.frame.width * 0.8333333
        let height = sender.frame.height * 0.8333333
        let x = sender.frame.origin.x + (width * 0.1)
        let y = sender.frame.origin.y + (height * 0.2)
        sender.frame = CGRect(x: x , y: y, width: width, height: height)
    }
    
    
}



extension MapCell{
    
       
       func viewForZooming(in scrollView: UIScrollView) -> UIView? {
           return self.scrollView.viewWithTag(5)
       }
       
       func scrollViewDidZoom(_ scrollView: UIScrollView) {
           updatePinPosition()
       }
       
       func updatePinPosition(){
    
           
           for text in textList{
               let newWidth = self.textPosition[text]![0] / scrollView.zoomScale
               let newHeight = self.textPosition[text]![1] / scrollView.zoomScale
               let difWidth = self.textPosition[text]![0] - newWidth
               let difHeight = self.textPosition[text]![1] - newHeight
               let newX = textPosition[text]![2] + (difWidth / 2)
               let newY = textPosition[text]![3] + (difHeight / 2)
               
               text.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
           }
           
           for text in textList2{
               let newWidth = self.textPosition[text]![0] / scrollView.zoomScale
               let newHeight = self.textPosition[text]![1] / scrollView.zoomScale
               let difWidth = self.textPosition[text]![0] - newWidth
               let difHeight = self.textPosition[text]![1] - newHeight
               let newX = textPosition[text]![2] + (difWidth / 5)
               let newY = textPosition[text]![3] + (difHeight / 2)
               
               text.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
           }
           
           
       }
    
}


extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
