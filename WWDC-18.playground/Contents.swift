//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import UIKit

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
sceneView.showsFPS = true
sceneView.showsNodeCount = true
sceneView.ignoresSiblingOrder = true

if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    scene.physicsBody = SKPhysicsBody(edgeLoopFrom:  CGRect(x: -320, y: -130, width: scene.frame.width, height: 370))
    sceneView.showsPhysics = true
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
