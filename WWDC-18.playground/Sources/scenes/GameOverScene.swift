import SpriteKit

class GameOverScene: SKScene {
    let won:Bool
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        let nextButton : SKSpriteNode = SKSpriteNode(imageNamed: "nextButton")
        let playButton : SKSpriteNode = SKSpriteNode(imageNamed: "playButton")
        if (won) {
            background = SKSpriteNode(imageNamed: "win")
//            run(SKAction.playSoundFileNamed(""win".wav",
//                                            waitForCompletion: false))
        } else {
            background = SKSpriteNode(imageNamed: "lose")
//            run(SKAction.playSoundFileNamed("lose.wav",
//                                            waitForCompletion: false))
        }
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        nextButton.zPosition = 1
        playButton.zPosition = 1
        self.addChild(background)
        self.addChild(nextButton)
        self.addChild(playButton)
    }
}
