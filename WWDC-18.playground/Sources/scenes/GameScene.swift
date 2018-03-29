import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    // Constants
    let distanceJump : CGFloat = 60
    let distanceMove : CGFloat = 10
    let moveDuration : Double = 0.1
    let checkpoints = [CGPoint(x: 0, y: 0)]
    var checkpointIndex = 0
    
    // Variables
    var lives = 2
    
    // Nodes
    private var background : SKNode!
    private var player : SKSpriteNode!
    private var livesLabel : SKLabelNode!
    private var frenchFlag : SKLabelNode!
    private var swedishFlag : SKLabelNode!
    private var usFlag : SKLabelNode!
    
    // Buttons
    private var buttonLeft : SKSpriteNode!
    private var buttonRight : SKSpriteNode!
    private var buttonJump : SKSpriteNode!
    
    private var lastBackgroundPosition : CGPoint = CGPoint.zero
    
    // Actions
    private var moveLeftAction : SKAction!
    private var moveRightAction : SKAction!
    private var moveAction: SKAction!
    private var playerRunLeftAction: SKAction!
    private var playerRunRightAction: SKAction!
    private var playerJumpLeftAction: SKAction!
    private var playerJumpRightAction: SKAction!
    private var playerKilledAction: SKAction!
    
    public override func didMove(to view: SKView) {
        // Physics
        physicsWorld.contactDelegate = self
        
        // Background
        if let _background = childNode(withName: "//background1") {
            background = _background
            background.zPosition = -1
        }
        
        // Player
        if let _player = childNode(withName: "//player") as? SKSpriteNode {
            player = _player
            player.zPosition = 2
            player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        }
        
        // Lifes
        if let _livesLabel = childNode(withName: "//lives") as? SKLabelNode {
            livesLabel = _livesLabel
            livesLabel.zPosition = 3
        }
        
        // Flags
        if let _flag = childNode(withName: "//fr_flag") as? SKLabelNode {
            frenchFlag = _flag
            frenchFlag.zPosition = 1
        }
        if let _flag = childNode(withName: "//sw_flag") as? SKLabelNode {
            swedishFlag = _flag
            swedishFlag.zPosition = 1
        }
        if let _flag = childNode(withName: "//us_flag") as? SKLabelNode {
            usFlag = _flag
            usFlag.zPosition = 1
        }
        
        // Buttons
        if let _buttonLeft = childNode(withName: "//buttonLeft") as? SKSpriteNode {
            buttonLeft = _buttonLeft
            buttonLeft.zPosition = 4
        }
        if let _buttonRight = childNode(withName: "//buttonRight") as? SKSpriteNode {
            buttonRight = _buttonRight
            buttonRight.zPosition = 4
        }
        if let _buttonJump = childNode(withName: "//buttonJump") as? SKSpriteNode {
            buttonJump = _buttonJump
            buttonJump.zPosition = 4
        }
        
        // Bricks
        enumerateChildNodes(withName: "//brick") { node, _ in
            if let brick = node as? SKSpriteNode {
                brick.zPosition = 1
            }
        }
        
        // Robots
        enumerateChildNodes(withName: "//robot") { node, _ in
            if let robot = node as? SKSpriteNode {
                robot.zPosition = 1
            }
        }
        
        // Actions
        moveAction = SKAction.move(by:  CGVector(dx:distanceMove, dy:0), duration: moveDuration)
        moveLeftAction = SKAction.repeatForever(SKAction.sequence([moveAction]))
        moveRightAction = SKAction.repeatForever(SKAction.sequence([moveAction.reversed()]))
        if let node = SKNode(fileNamed: "Actions"), let actions = node.value(forKey: "actions") as? [String:SKAction] {
            playerRunLeftAction = actions["playerRunLeft"]
            playerRunRightAction = actions["playerRunRight"]
            playerJumpLeftAction = actions["playerJumpLeft"]
            playerJumpRightAction = actions["playerJumpRight"]
            playerKilledAction = actions["playerKilled"]
        } else {
            print("fail")
        }
        
        // UI Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(jump(sender:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "robot" {
            playerKilled()
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Update checkpoint
        if checkpointIndex < checkpoints.count-1 {
            if background.position.distance(to: checkpoints[checkpointIndex]) >
                background.position.distance(to: checkpoints[checkpointIndex+1]) {
                checkpointIndex += 1
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
            if name == "buttonLeft" {
                moveLeft()
            } else if name == "buttonRight" {
                moveRight()
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "buttonLeft" {
                stopMoveLeft()
            } else if name == "buttonRight" {
                stopMoveRight()
            }
        }
    }
    
    func playerKilled() {
        print("Player killed")
        self.lives -= 1
        if self.lives > 0 {
            // Player
            initPlayer()
            player.run(playerKilledAction, withKey: "playerKilled")

            // Background
            background.run(SKAction.move(to: checkpoints[checkpointIndex], duration: 1.0))
            
            // Live
            self.livesLabel.text = ""
            for _ in 1...self.lives {
                self.livesLabel.text! += "❤️"
            }
        } else {
            gameFinished(won: false)
        }
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
    
    // Actions
    func moveLeft() {
        print("Move left started")
        stopMoveRight()
        background.run(moveLeftAction, withKey: "moveLeft")
        //player.run(playerRunLeftAction, withKey: "runLeft")
    }
    
    func stopMoveLeft() {
        print("Move left ended")
        background.removeAction(forKey: "moveLeft")
        background.removeAction(forKey: "moveRight")
        player.texture = SKTexture(imageNamed:"playerLeft")
    }
    
    func moveRight() {
        print("Move right started")
        background.run(moveRightAction, withKey: "moveRight")
        //player.run(playerRunRightAction, withKey: "runRight")
    }
    
    func stopMoveRight() {
        print("Move right ended")
        background.removeAction(forKey: "moveLeft")
        background.removeAction(forKey: "moveRight")
        player.texture = SKTexture(imageNamed:"playerRight")
    }
    
    @objc func jump(sender: UITapGestureRecognizer) {
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distanceJump))
    }
}
