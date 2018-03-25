//
//  ViewController.swift
//  Linijka
//
//  Created by Adam Stanislawski on 25.03.2018.
//  Copyright © 2018 Adam Stanislawski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first {
                
                addDot(at: hitResult)
                
            }
            
        }
        
    }
    
    func addDot(at hitResult : ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            
            calculate()
            
        }
        
    }
    
    func calculate() {
        
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = start.position.x - end.position.x
        let b = start.position.y - end.position.y
        let c = start.position.z - end.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
        print(distance)
        
    }

}
