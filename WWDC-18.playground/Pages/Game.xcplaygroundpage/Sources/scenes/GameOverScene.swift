import SpriteKit

public class GameOverScene: SKScene {
    var won : Bool = true
    
    // Buttons
    private var buttonRetry : SKSpriteNode!
    private var buttonMenu : SKSpriteNode!
    private var background : SKSpriteNode!
    private var label : SKLabelNode!

    public override func didMove(to view: SKView) {
        // Physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Background
        if let _background = childNode(withName: "//background") as? SKSpriteNode {
            background = _background
            background.zPosition = -1
        }
        
        // Label
        if let _label = childNode(withName: "//label") as? SKLabelNode {
            label = _label
            label.zPosition = 3
        }
        
        // Buttons
        if let _button = childNode(withName: "//buttonRetry") as? SKSpriteNode {
            buttonRetry = _button
            buttonRetry.zPosition = 3
        }
        
        if let _button = childNode(withName: "//buttonMenu") as? SKSpriteNode {
            buttonMenu = _button
            buttonMenu.zPosition = 3
        }
        
        // Song
        if (won) {
            label.text = "You won !"
            //            run(SKAction.playSoundFileNamed(""win".wav",
            //                                            waitForCompletion: false))
        } else {
            label.text = "You loose"
            //            run(SKAction.playSoundFileNamed("lose.wav",
            //                                            waitForCompletion: false))
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "buttonRetry" || name == "labelRetry" {
                if let scene = GameScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: reveal)
                }
            } else if name == "buttonMenu" || name == "labelMenu" {
                
            }
        }
    }
}
