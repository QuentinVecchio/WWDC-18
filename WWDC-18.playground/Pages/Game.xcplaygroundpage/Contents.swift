//: [Previous](@previous)
import PlaygroundSupport
import SpriteKit
import UIKit

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
sceneView.showsFPS = true
sceneView.showsNodeCount = true
sceneView.ignoresSiblingOrder = true

if let scene = PresentationScene(fileNamed: "PresentationScene") {
    scene.scaleMode = .aspectFill
    sceneView.showsPhysics = true
    sceneView.presentScene(scene)
}

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//: [Next](@next)
