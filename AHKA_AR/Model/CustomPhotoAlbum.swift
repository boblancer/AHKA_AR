//
//  CustomAlbum.swift
//  AHKA_AR
//
//  Created by sartsawatj on 3/22/20.
//  Copyright © 2020 boblancer. All rights reserved.
//

import Foundation
import Photos

import UIKit

class CustomPhotoAlbum {
    
    static let albumName = "AHKA AR"
    static let sharedInstance = CustomPhotoAlbum()
    var manager = PHImageManager.default()
    var assetCollection: PHAssetCollection!
    
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var persistentService = PersistentService()

    init() {
        
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let firstObject: AnyObject = collection.firstObject {
                return collection.firstObject as? PHAssetCollection
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            print(persistentService.getAlbumReference(), "\nfound ref")
            return
        }
        print("requesting asset creation")
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
                self.persistentService.saveAlbumReference(value: self.assetCollection!.localIdentifier)
                print(self.assetCollection.localIdentifier)
    
            }
        }
    }
    
    func fetchImages() -> PHFetchResult<PHAsset>{
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(in: self.assetCollection, options: fetchOptions)
        return results

    }
    
    func saveImage(image: UIImage) -> Bool {
        
        if assetCollection == nil {
            print("Returning true")
            return false
        }
        print("returning true")
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
        }, completionHandler: nil)
        return true
        
    }

    
}
