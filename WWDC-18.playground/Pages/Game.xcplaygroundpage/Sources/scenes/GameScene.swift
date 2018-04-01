import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    // Constants
    let distanceJump : CGFloat = 55
    let checkpoints = [CGPoint(x: 0, y: 0), CGPoint(x: -1820, y: 0), CGPoint(x: -3740, y: 0), CGPoint(x: -4460, y: 0)]
    
    // Variables
    var lives = 5
    var chronoValue = 3
    var checkpointIndex = 0
    var isResumed = false
    var canJump = false
    var playerIsKilled = false
    
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
    private var window : SKSpriteNode!
    private var chrono : SKLabelNode!
    
    // Buttons
    private var buttonPause : SKSpriteNode!
    private var buttonResume : SKSpriteNode!
    private var buttonQuit : SKSpriteNode!
    
    // Actions
    private var playerKilledAction: SKAction!
    private var playerRunAction: SKAction!
    private var moveAction: SKAction!
    private var playerHappy: SKAction!
    
    public override func didMove(to view: SKView) {
        // Physics
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -10, y: 0, width: self.frame.width+10, height: 755))
        
        // Actions
        if let node = SKNode(fileNamed: "Actions"), let actions = node.value(forKey: "actions") as? [String:SKAction] {
            playerKilledAction = actions["playerKilled"]
            playerRunAction = actions["playerRun"]
            moveAction = actions["move"]
            playerHappy = actions["playerHappy"]
        } else {
            print("Failed to load Action.")
        }
        
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
        if let _button = childNode(withName: "//buttonPause") as? SKSpriteNode {
            buttonPause = _button
            buttonPause.zPosition = 5
        }
        
        if let _button = childNode(withName: "//buttonResume") as? SKSpriteNode {
            buttonResume = _button
            buttonResume.isHidden = true
            buttonResume.zPosition = 7
        }
        
        if let _button = childNode(withName: "//buttonQuit") as? SKSpriteNode {
            buttonQuit = _button
            buttonQuit.isHidden = true
            buttonQuit.zPosition = 7
        }
        
        // Chrono
        if let _chrono = childNode(withName: "//chrono") as? SKLabelNode {
            chrono = _chrono
            chrono.zPosition = 7
        }
        
        // Windows
        if let _window = childNode(withName: "//window") as? SKSpriteNode {
            window = _window
            window.zPosition = 6
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
                brick.zPosition = 3
            }
        }
        
        // Robots
        enumerateChildNodes(withName: "//robot") { node, _ in
            if let robot = node as? SKSpriteNode {
                robot.zPosition = 3
            }
        }
        
        resume()
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node?.name, let nodeB = contact.bodyB.node?.name {
            if (nodeA == "robot" || nodeB == "robot") && (nodeA == "player" || nodeB == "player") && !playerIsKilled {
                playerIsKilled = true
                playerKilled()
            } else if (nodeA == "bottom" || nodeB == "bottom") && (nodeA == "player" || nodeB == "player") {
                if player.action(forKey: "run") == nil && !canJump && isResumed {
                    player.run(self.playerRunAction, withKey: "run")
                    canJump = true
                }
            } else if (nodeA == "brick" || nodeB == "brick") && (nodeA == "player" || nodeB == "player") && isResumed {
                if player.action(forKey: "run") == nil && isResumed {
                    player.run(self.playerRunAction, withKey: "run")
                    canJump = true
                }
            }
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Update checkpoint
        if checkpointIndex < checkpoints.count-1 {
            checkpointIndex = checkpoints.count-1
            for i in 0..<(checkpoints.count-1) {
                if world.position.x <= checkpoints[i].x && world.position.x > checkpoints[i+1].x {
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
                runWWDCAnimation()
            default:
                frEmoji.alpha = 1
            }
        }
        
        // Check if the player is late
        if player.position.x < 0 && !playerIsKilled {
            playerIsKilled = true
            playerKilled()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "buttonPause" {
                pause()
            } else if name == "buttonResume" || name == "labelResume" {
                resume()
            } else if name == "buttonQuit" || name == "labelQuit" {
                
            } else {
                jump()
            }
        }
    }
    
    func resume() {
        buttonResume.isHidden = true
        buttonQuit.isHidden = true
        chronoValue = 3
        chrono.text = "\(self.chronoValue)"
        chrono.isHidden = false
        
        // Chrono
        let hideWindow = SKAction.run() {
            self.window.isHidden = true
            self.buttonPause.isHidden = false
            self.player.isPaused = false
            self.world.isPaused = false
            self.player.run(self.playerRunAction, withKey: "run")
            self.world.run(self.moveAction, withKey: "move")
            self.canJump = true
            self.isResumed = true
        }
        let updateChrono = SKAction.run() {
            self.chronoValue -= 1
            self.chrono.text = "\(self.chronoValue)"
        }
        let sequence = SKAction.sequence(
            [SKAction.wait(forDuration: 1.0), updateChrono,
             SKAction.wait(forDuration: 1.0), updateChrono,
             SKAction.wait(forDuration: 1.0), hideWindow])
        chrono.run(sequence)
    }
    
    func pause() {
        isResumed = false
        canJump = false
        buttonResume.isHidden = false
        buttonQuit.isHidden = false
        player.isPaused = true
        world.isPaused = true
        window.isHidden = false
        buttonPause.isHidden = true
        chrono.isHidden = true
    }
    
    func playerKilled() {
        print("Player killed")
        self.lives -= 1
        if self.lives > 0 {
            // Player
            movePlayerToInitPoint()

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

    func runWWDCAnimation() {
        print("Finished !!!")
        canJump = false
        isResumed = false
        
        world.removeAction(forKey: "move")
        buttonPause.isHidden = true
        
        let finished = SKAction.run() {
            self.gameFinished(won: true)
        }
        let playerHappyJump = SKAction.run() {
            self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        }
        let playerIsHappy = SKAction.run() {
            self.player.texture = SKTexture(imageNamed:"playerHappy")
            let seq = SKAction.sequence([   playerHappyJump,
                                            SKAction.wait(forDuration: 1.5),
                                            playerHappyJump,
                                            SKAction.wait(forDuration: 1.5),
                                            playerHappyJump,
                                            SKAction.wait(forDuration: 1.5),
                                            finished])
            self.player.run(seq)
        }
        let removeActionRun = SKAction.run() {
            self.player.removeAction(forKey: "run")
        }
        let sequence = SKAction.sequence(
            [SKAction.moveBy(x: 460, y: 0, duration: 4.0),
             removeActionRun,
             playerIsHappy])
        player.run(sequence)
    }
    
    func gameFinished(won: Bool) {
        if let gameOverScene = GameOverScene(fileNamed: "GameOverScene") {
            gameOverScene.scaleMode = .aspectFill
            gameOverScene.won = won
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func movePlayerToInitPoint() {
        self.player.isHidden = true
        let setPlayerIsKilled = SKAction.run() {
            self.playerIsKilled = false
            self.player.isHidden = false
        }
        let sequence = SKAction.sequence([SKAction.move(to: CGPoint(x: 130, y: 160), duration: 1.0), setPlayerIsKilled])
        player.run(sequence)
        player.removeAction(forKey: "runLeft")
        player.removeAction(forKey: "runRight")
        player.removeAction(forKey: "jump")
        player.texture = SKTexture(imageNamed:"playerRight")
    }
    
    func jump() {
        if canJump {
            player.removeAction(forKey: "run")
            player.texture = SKTexture(imageNamed:"playerJump")
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distanceJump))
            canJump = false
        }
    }
}
