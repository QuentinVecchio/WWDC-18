import SpriteKit

public class GameScene: SKScene {
    // Constants
    let distanceMove : CGFloat = 80
    let moveDuration : Double = 1.5
    let checkpoints = [CGPoint(x: -200, y: -80)]
    
    // Variables
    var lives = 5
    
    // Nodes
    private var background : SKNode!
    private var player : SKSpriteNode!
    private var livesLabel : SKLabelNode!
    
    // Buttons
    private var buttonLeft : SKSpriteNode!
    private var buttonRight : SKSpriteNode!
    
    private var lastBackgroundPosition : CGPoint = CGPoint.zero
    
    // Actions
    private var moveLeftAction : SKAction!
    private var moveRightAction : SKAction!
    private var moveAction: SKAction!
    private var playerRunLeftAction: SKAction!
    private var playerRunRightAction: SKAction!
    
    public override func didMove(to view: SKView) {
        // Background
        if let _background = childNode(withName: "//background") {
            background = _background
            background.zPosition = -1
        }
        
        // Player
        if let _player = childNode(withName: "//player") as? SKSpriteNode {
            player = _player
            player.zPosition = 2
        }
        
        // Lifes
        if let _livesLabel = childNode(withName: "//lives") as? SKLabelNode {
            livesLabel = _livesLabel
            livesLabel.zPosition = 10
        }
        
        // Buttons
        if let _buttonLeft = childNode(withName: "//buttonLeft") as? SKSpriteNode {
            buttonLeft = _buttonLeft
            buttonLeft.zPosition = 3
        }
        if let _buttonRight = childNode(withName: "//buttonRight") as? SKSpriteNode {
            buttonRight = _buttonRight
            buttonRight.zPosition = 3
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
        } else {
            print("fail")
        }
        
        // UI Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(jump))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    public override func didEvaluateActions() {
        checkCollisions()
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
    
    func checkCollisions() {
        // Collision with robots
        enumerateChildNodes(withName: "//robot") { node, _ in
            if let robot = node as? SKSpriteNode {
                if robot.frame.intersects(self.player.frame) {
                    print("Collision")
                    self.playerKilled()
                    return
                }
            }
        }
    }
    
    func playerKilled() {
        self.lives -= 1
        if self.lives > 0 {
            // We search the nearest checkpoint and we move the player (background) position to this position
            
            // We refresh the life
            self.livesLabel.text = ""
            for _ in 1...self.lives {
                self.livesLabel.text = "❤️"
            }
        } else {
            gameover()
        }
    }
    
    func gameover() {
        
    }
    
    // Actions
    func moveLeft() {
        if background.action(forKey: "moveLeft") == nil {
            print("Move left started")
            stopMoveRight()
            background.run(self.moveLeftAction, withKey: "moveLeft")
            //player.run(playerRunLeftAction, withKey: "runLeft")
        }
    }
    
    func stopMoveLeft() {
        print("Move left ended")
        if background.action(forKey: "moveLeft") != nil {
            background.removeAction(forKey: "moveLeft")
            player.texture = SKTexture(imageNamed:"playerLeft")
        }
    }
    
    func moveRight() {
        if background.action(forKey: "moveRight") == nil {
            print("Move right started")
            stopMoveLeft()
            background.run(self.moveRightAction, withKey: "moveRight")
            //player.run(playerRunRightAction, withKey: "runRight")
        }
    }
    
    func stopMoveRight() {
        print("Move right ended")
        if background.action(forKey: "moveRight") != nil {
            background.removeAction(forKey: "moveRight")
            player.texture = SKTexture(imageNamed:"playerRight")
            player.removeAction(forKey: "runRight")
        }
    }

    @objc func jump() {
        print("Jump")
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
    }
}
