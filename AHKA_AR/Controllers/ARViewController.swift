//
//  ViewController.swift
//  AHKA_AR
//
//  Created by sartsawatj on 2/1/20.
//  Copyright © 2020 boblancer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    @IBOutlet var sceneView: ARSCNView!
    var image: UIImage!
    var mainScene: SCNScene!
    var modelDidAppear: Bool = false
    var characters = [SCNScene?](repeating: nil, count: 12)


    @IBAction func snapshotButtonPressed(_ sender: AnyObject){
        image = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        setUpScene()
        
    }

    func setUpScene(){
        
        modelDidAppear = false
        let mainScene = SCNScene()
//        let node = SCNScene(named: "art.scnassets/Pig2.scn")?.rootNode
//        node?.scale = SCNVector3Make(10, 10, 10)
//        mainScene.rootNode.addChildNode(node ?? SCNNode())
//        mainScene.rootNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
        sceneView.scene = mainScene
        for i in 0...11{
            characters[i] = SCNScene(named: "art.scnassets/ship.scn")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        if let detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "ARTarget",
            bundle: Bundle.main){
            configuration.detectionImages = detectionImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        // Run the view's session
        sceneView.session.run(configuration)
        modelDidAppear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if anchor is ARImageAnchor && !modelDidAppear {
             DispatchQueue.global().async {
//            let plane = SCNPlane(width: 10, height: 10)
//            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//            let planeNode = SCNNode(geometry: plane)
                let jetScn = SCNScene(named: "art.scnassets/ship.scn")
                let jetNode = jetScn?.rootNode
                node.addChildNode((jetNode ?? nil)!)
                self.modelDidAppear = true
                print("image detected")
            }
        }
        return node
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create i8and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
