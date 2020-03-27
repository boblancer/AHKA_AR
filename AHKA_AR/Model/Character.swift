//
//  Character.swift
//  AHKA_AR
//
//  Created by sartsawatj on 2/27/20.
//  Copyright © 2020 boblancer. All rights reserved.
//

import UIKit
import SceneKit
class Character: SCNNode {
        
    convenience init(named name: String) {
        self.init()
        
        guard let scene = SCNScene(named: name) else {
            return
        }
        
        for childNode in scene.rootNode.childNodes {
            addChildNode(childNode)
        }
    }
}
