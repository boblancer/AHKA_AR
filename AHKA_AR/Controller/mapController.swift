//
//  mapController.swift
//  AHKA_AR
//
//  Created by Kanokporn Wongwaitayakul on 24/2/2563 BE.
//  Copyright © 2563 boblancer. All rights reserved.
//

import UIKit
class MapController: UIViewController{
    
    @IBOutlet weak var mapView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.dataSource = self
        mapView.delegate = self
        mapView.isPagingEnabled = true
        mapView.register(UINib(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        mapView.reloadData()
    }
}

extension MapController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
        
        // 1795 1038
        let img = #imageLiteral(resourceName: "map")
        let heightRatio = mapView.frame.size.height / 1038
        let width = 1795 * heightRatio
        
        let newImg = img.resizeImageWith(newSize: CGSize(width: width, height: mapView.frame.size.height))
        
        cell.mapView.image = newImg
        cell.scrollView.contentSize = newImg.size
        
        for pin in cell.pinList{
            let width = pin.frame.size.width * heightRatio
            let height = pin.frame.size.height * heightRatio
            let x = pin.frame.origin.x * heightRatio
            let y = pin.frame.origin.y * heightRatio
            
            cell.pinPosition[pin] = [width, height, x, y]
            pin.frame = CGRect(x: x , y: y, width: width, height: height)
        
        }
        
        for pin in cell.pinList2{
            let width = pin.frame.size.width * heightRatio
            let height = pin.frame.size.height * heightRatio
            let x = pin.frame.origin.x * heightRatio
            let y = pin.frame.origin.y * heightRatio
            
            cell.pinPosition[pin] = [width, height, x, y]
            pin.frame = CGRect(x: x , y: y, width: width, height: height)
        }
        return cell
    }

    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = mapView.bounds.width
        let yourHeight = mapView.bounds.height
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
}
