import SpriteKit

public class PresentationScene: SKScene {
 
    public override func didMove(to view: SKView) {
        enumerateChildNodes(withName: "//message") { node, _ in
            if let message = node as? SKLabelNode {
                message.zPosition = 1
            }
        }
        
        enumerateChildNodes(withName: "//bottom") { node, _ in
            if let bottom = node as? SKSpriteNode {
                bottom.zPosition = 1
            }
        }
        
        enumerateChildNodes(withName: "//landscape") { node, _ in
            if let bottom = node as? SKSpriteNode {
                bottom.zPosition = 1
            }
        }
        
        enumerateChildNodes(withName: "//player") { node, _ in
            if let player = node as? SKSpriteNode {
                player.zPosition = 2
            }
        }
        
        enumerateChildNodes(withName: "//tap") { node, _ in
            if let tap = node as? SKSpriteNode {
                tap.zPosition = 2
            }
        }
        
        enumerateChildNodes(withName: "//hand") { node, _ in
            if let hand = node as? SKLabelNode {
                hand.zPosition = 3
            }
        }
        
        enumerateChildNodes(withName: "//background") { node, _ in
            if let background = node as? SKSpriteNode {
                background.zPosition = -1
            }
        }
        
        enumerateChildNodes(withName: "//buttonPlay") { node, _ in
            if let button = node as? SKSpriteNode {
                button.zPosition = 1
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "buttonPlay" || name == "labelPlay" {
                if let scene = GameScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: reveal)
                }
            }
        }
    }
}
