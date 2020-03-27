//
//  AlbumViewController.swift
//  AHKA_AR
//
//  Created by sartsawatj on 2/20/20.
//  Copyright © 2020 boblancer. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UICollectionViewController,PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("changed")
    }
    
    
    var imageArr = [UIImage]()    
    var customPhotoAlbum  = CustomPhotoAlbum()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotos();
        PHPhotoLibrary.shared().register(self)
        collectionView.delegate = self
    
    
        // Do any additional setup after loading the view.
    }
    func getPhotos() {
        
        let results = self.customPhotoAlbum.fetchImages()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 200, height: 200)
                self.customPhotoAlbum.manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, err) in
                    if let image = image {
                        self.imageArr.append(image)
                        self.collectionView.reloadData()
                    } else {
                        print(err!)
                    }
                }
            }
        } else {
            print("no photos to display")
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArr[indexPath.row]
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat{
//        return 0.1
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AlbumViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 3
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
