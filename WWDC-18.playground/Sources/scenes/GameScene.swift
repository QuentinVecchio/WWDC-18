import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    // Constants
    let distanceJump : CGFloat = 70
    let checkpoints = [CGPoint(x: 0, y: 0), CGPoint(x: -1920, y: 0), CGPoint(x: -3840, y: 0), CGPoint(x: -4480, y: 0)]
    
    // Variables
    var lives = 2
    var checkpointIndex = 0
    var isResumed = false
    var canJump = true
    
    // Nodes
    private var world : SKNode!
    private var player : SKSpriteNode!
    private var livesLabel : SKLabelNode!
    private var frFlag : SKSpriteNode!
    private var swFlag : SKSpriteNode!
    private var usFlag : SKSpriteNode!
    private var wwdcFlag : SKSpriteNode!
    private var frEmoji : SKLabelNode!
    private var swEmoji : SKLabelNode!
    private var usEmoji : SKLabelNode!
    private var wwdcEmoji : SKLabelNode!
    
    // Buttons
    private var buttonResumePause : SKSpriteNode!
    
    // Actions
    private var playerKilledAction: SKAction!
    
    public override func didMove(to view: SKView) {
        // Physics
        physicsWorld.contactDelegate = self
        
        // World
        if let _world = childNode(withName: "//world") {
            world = _world
        }
        
        // Background
        enumerateChildNodes(withName: "//background") { node, _ in
            if let background = node as? SKSpriteNode {
                background.zPosition = -1
            }
        }
        
        // Player
        if let _player = childNode(withName: "//player") as? SKSpriteNode {
            player = _player
            player.zPosition = 3
            player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        }
        
        // Lives
        if let _livesLabel = childNode(withName: "//lives") as? SKLabelNode {
            livesLabel = _livesLabel
            livesLabel.zPosition = 4
        }
        
        // Flags
        if let _flag = childNode(withName: "//fr_flag") as? SKSpriteNode {
            frFlag = _flag
            frFlag.zPosition = 2
        }
        
        if let _flag = childNode(withName: "//sw_flag") as? SKSpriteNode {
            swFlag = _flag
            swFlag.zPosition = 2
        }
        
        if let _flag = childNode(withName: "//us_flag") as? SKSpriteNode {
            usFlag = _flag
            usFlag.zPosition = 2
        }
        
        if let _flag = childNode(withName: "//wwdc_flag") as? SKSpriteNode {
            wwdcFlag = _flag
            wwdcFlag.zPosition = 2
        }
        
        // Emojis
        if let _emoji = childNode(withName: "//fr_emoji") as? SKLabelNode {
            frEmoji = _emoji
            frEmoji.zPosition = 4
        }
        
        if let _emoji = childNode(withName: "//sw_emoji") as? SKLabelNode {
            swEmoji = _emoji
            swEmoji.zPosition = 4
        }
        
        if let _emoji = childNode(withName: "//us_emoji") as? SKLabelNode {
            usEmoji = _emoji
            usEmoji.zPosition = 4
        }
        
        if let _emoji = childNode(withName: "//wwdc_emoji") as? SKLabelNode {
            wwdcEmoji = _emoji
            wwdcEmoji.zPosition = 4
        }
        
        // Buttons
        if let _buttonResumePause = childNode(withName: "//buttonResumePause") as? SKSpriteNode {
            buttonResumePause = _buttonResumePause
            buttonResumePause.zPosition = 5
        }
        
        // Bottom
        enumerateChildNodes(withName: "//bottom") { node, _ in
            if let bottom = node as? SKSpriteNode {
                bottom.zPosition = 2
            }
        }
        
        // Bricks
        enumerateChildNodes(withName: "//brick") { node, _ in
            if let brick = node as? SKSpriteNode {
                brick.zPosition = 2
            }
        }
        
        // Robots
        enumerateChildNodes(withName: "//robot") { node, _ in
            if let robot = node as? SKSpriteNode {
                robot.zPosition = 2
            }
        }
        
        // Actions
        if let node = SKNode(fileNamed: "Actions"), let actions = node.value(forKey: "actions") as? [String:SKAction] {
            playerKilledAction = actions["playerKilled"]
        } else {
            print("Failed to load Action.")
        }
        
        // Physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.frame.width, height: 755))
        
        resume()
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node?.name, let nodeB = contact.bodyB.node?.name {
            if (nodeA == "robot" || nodeB == "robot") && (nodeA == "player" || nodeB == "player") {
                playerKilled()
            } else if (nodeA == "bottom" || nodeB == "bottom") && (nodeA == "player" || nodeB == "player") {
                canJump = true
            } else if (nodeA == "brick" || nodeB == "brick") && (nodeA == "player" || nodeB == "player") {
                canJump = true
            }
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Update checkpoint
        if checkpointIndex < checkpoints.count-1 {
            for i in 0..<(checkpoints.count-1) {
                if world.position.x >= checkpoints[i].x && world.position.x < checkpoints[i+1].x {
                    checkpointIndex = i
                    break
                }
            }
            switch checkpointIndex {
            case 1 :
                swEmoji.alpha = 1
            case 2 :
                usEmoji.alpha = 1
            case 3:
                wwdcEmoji.alpha = 1
                animationFinished()
            default:
                frEmoji.alpha = 1
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
            if name == "buttonResumePause" {
                if isResumed {
                    pause()
                } else {
                    resume()
                }
            } else {
                jump()
            }
        }
    }
    
    func resume() {
        isResumed = true
        buttonResumePause.texture = SKTexture(imageNamed:"buttonPause")
        player.isPaused = false
        world.isPaused = false
    }
    
    func pause() {
        isResumed = false
        buttonResumePause.texture = SKTexture(imageNamed:"buttonResume")
        player.isPaused = true
        world.isPaused = true
    }
    
    func playerKilled() {
        print("Player killed")
        self.lives -= 1
        if self.lives > 0 {
            // Player
            initPlayer()
            player.run(playerKilledAction, withKey: "playerKilled")

            // World
            world.run(SKAction.move(to: checkpoints[checkpointIndex], duration: 1.0))
            
            // Live
            self.livesLabel.text = ""
            for _ in 1...self.lives {
                self.livesLabel.text! += "❤️"
            }
        } else {
            gameFinished(won: false)
        }
    }

    func animationFinished() {
        world.removeAction(forKey: "move")
        print("Finished !!!")
    }
    
    func gameFinished(won: Bool) {
        let gameOverScene = GameOverScene(size: size, won: false)
        gameOverScene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: reveal)
    }
    
    func initPlayer() {
        player.position = CGPoint(x: 130, y: 160)
        player.removeAction(forKey: "runLeft")
        player.removeAction(forKey: "runRight")
        player.removeAction(forKey: "jump")
        player.texture = SKTexture(imageNamed:"playerRight")
    }
    
    func jump() {
        if canJump {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distanceJump))
            canJump = false
        }
    }
}
