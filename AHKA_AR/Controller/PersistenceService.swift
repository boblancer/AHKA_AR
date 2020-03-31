//
//  PersistenceService.swift
//  AHKA_AR
//
//  Created by sartsawatj on 3/22/20.
//  Copyright © 2020 boblancer. All rights reserved.
//

import Foundation
import CoreData

class PersistentService{
    var defaults = UserDefaults.standard

    func saveBoolean(key: String, value: Bool) {
        defaults.set(value, forKey: key)
        print("\(value) is save for \(key)")
    }
    func getBooleanValueForKey(key: String) -> Bool {
        let found = defaults.bool(forKey: key)
        return found
    }
    func getAlbumReference() -> String {
        let found = defaults.object(forKey: "ref")
        return found! as! String
    }
    func saveAlbumReference(value: String){
        defaults.set(value, forKey: "ref")
    }
}
