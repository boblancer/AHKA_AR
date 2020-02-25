//
//  MapCell.swift
//  AHKA_AR
//
//  Created by Kanokporn Wongwaitayakul on 24/2/2563 BE.
//  Copyright © 2563 boblancer. All rights reserved.
//

import UIKit

class MapCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var noName1: UIButton!
    @IBOutlet weak var voodooHub: UIButton!
    @IBOutlet weak var coffeeRoasting: UIButton!
    @IBOutlet weak var noName2: UIButton!
    @IBOutlet weak var chiefHub: UIButton!
    @IBOutlet weak var visitorCenter: UIButton!
    @IBOutlet weak var cuturalCenter: UIButton!
    @IBOutlet weak var holyWell: UIButton!
    @IBOutlet weak var ghostDoor: UIButton!
    @IBOutlet weak var saoChingcha: UIButton!
    @IBOutlet weak var coffee: UIButton!
    @IBOutlet weak var skywalk: UIButton!
    
    @IBOutlet weak var text1: UIButton!
    @IBOutlet weak var text2: UIButton!
    @IBOutlet weak var text3: UIButton!
    @IBOutlet weak var text4: UIButton!
    
    var pinList: [UIButton] = []
    var pinList2: [UIButton] = []
    var pinPosition: [UIButton: [CGFloat]] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        setupPinPosition()
    }
    
    func setupPinPosition(){        
        pinList = [noName1, voodooHub, noName2, chiefHub, cuturalCenter, holyWell, ghostDoor, saoChingcha, coffee, text1, text2]
        pinList2 = [coffeeRoasting, visitorCenter, skywalk, text3, text4]
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollView.viewWithTag(5)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //updatePinPosition()
    }
    
    func updatePinPosition(){
        //let heightRatio = scrollView.bounds.size.height / 1038
        
        for pin in pinList{
            let newWidth = self.pinPosition[pin]![0] / scrollView.zoomScale
            let newHeight = self.pinPosition[pin]![1] / scrollView.zoomScale
            let difWidth = self.pinPosition[pin]![0] - newWidth
            let difHeight = self.pinPosition[pin]![1] - newHeight
            let newX = pinPosition[pin]![2] + (difWidth / 2)
            let newY = pinPosition[pin]![3] + difHeight
            
            pin.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        }
        
        for pin in pinList2{
            let newWidth = self.pinPosition[pin]![0] / scrollView.zoomScale
            let newHeight = self.pinPosition[pin]![1] / scrollView.zoomScale
            let difWidth = self.pinPosition[pin]![0] - newWidth
            let difHeight = self.pinPosition[pin]![1] - newHeight
            let newX = pinPosition[pin]![2]
            let newY = pinPosition[pin]![3] 
            
            pin.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        }
        
        
    }
    
    
    
}



extension MapCell{
    
    @IBAction func pinPressed(_ sender: UIButton) {
        print(sender.accessibilityIdentifier)
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
