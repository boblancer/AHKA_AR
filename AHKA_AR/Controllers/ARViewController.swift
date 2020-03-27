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
    var persistetService = PersistentService()
    var customPhotoAlbum = CustomPhotoAlbum()


    @IBAction func snapshotButtonPressed(_ sender: AnyObject){
        image = sceneView.snapshot()
        let error = self.customPhotoAlbum.saveImage(image: image)
        if error{
            let ac = UIAlertController(title: "Save error", message: "fail to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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
        let mainScene = SCNScene()
        sceneView.scene = mainScene
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        let imageAnchor = (anchor is ARImageAnchor) ? anchor as? ARImageAnchor : nil
        if (imageAnchor != nil) && !(self.persistetService.GetBooleanValueForKey(key: imageAnchor!.referenceImage.name!)) {
             DispatchQueue.global().async {
//            let plane = SCNPlane(width: 10, height: 10)
//            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//            let planeNode = SCNNode(geometry: plane
                let s = (imageAnchor!.referenceImage.name)
                let characterIndex = s![(s!.index(s!.startIndex, offsetBy: 10)..<s!.endIndex)]
                print("the index is ", characterIndex, ".scn")
                let characterScn = SCNScene(named: "art.scnassets/Characters/\(characterIndex).scn")
                let characterNode = characterScn?.rootNode
                node.addChildNode(characterNode!)
                self.persistetService.SaveBoolean(key: String(characterIndex), value: true)
            }
        }
        return node
    }

    // MARK: - ARSCNViewDelegate

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        sceneView.session.pause()
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
