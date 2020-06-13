//
//  GameScene.swift
//  HelloSpriteKit
//
//  Created by Benyamin on 6/8/20.
//  Copyright © 2020 Benyamin. All rights reserved.
//

import SpriteKit
import GameplayKit


struct PhysicsCategory {
    static let dino: UInt32 = 0b1 // 1
    static let meteor: UInt32 = 0b10 // 2
    static let ground: UInt32 = 0b100 // 4
}


class GameScene: SKScene {
    
    var dino: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    
    var dinoDirection: CGFloat = 0.0
    
    var idleAction: SKAction!
    var runningAction: SKAction!
    
    var lives = 5
    var isAlive: Bool {
        return lives > 0
    }
    
    var gameSceneDelegate: GameSceneDelegate?
    
    override func didMove(to view: SKView) {
        setupSpawnAction()
        setupIdleAction()
        setupRunningAction()
               
        dino = (childNode(withName: "Dino") as! SKSpriteNode)
        leftButton = (childNode(withName: "//leftButton") as! SKSpriteNode)
        rightButton = (childNode(withName: "//rightButton") as! SKSpriteNode)
        
        dino.run(idleAction, withKey: "idleAnimation")
        dino.physicsBody?.restitution = 0.1
        
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -1792, y: 0, width: 1792 * 3, height: 1000) )
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if !isAlive { return }
        
        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
        
            if node == leftButton {
                dino.xScale = -1
                dino.removeAction(forKey: "idleAnimation")
                dino.run(runningAction, withKey: "runningAnimation")
                dinoDirection = -1
            } else if node == rightButton {
                dino.xScale = 1
                dino.removeAction(forKey: "idleAnimation")
                dino.run(runningAction, withKey: "runningAnimation")
                dinoDirection = 1
            } else if node == dino {
                let impulseVector = CGVector(dx: 250 * dino.xScale, dy: 750)
                dino.run(SKAction.applyImpulse(impulseVector, duration: 0.1))
            }
        }
    }
    
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isAlive { return }
        
        dinoDirection = 0
        dino.removeAction(forKey: "runningAnimation")
        dino.run(idleAction, withKey: "idleAnimation")
    }
    
   
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // update x position of dino based on current direction
        let newPosition = dino.position.x + (dinoDirection * 10)

        dino.position.x = newPosition
        
        if dino.position.x > -900 && dino.position.x < 2700 {
            camera?.position.x = newPosition
        }
        
        
    }
    
    func spawnBackgroundMeteor() {
        // 1. create SKSpriteNode for meteor
        let meteor = SKSpriteNode(imageNamed: "meteor4")
        meteor.zPosition = -5
        meteor.setScale(0.1)
        
        let x = CGFloat.random(in: camera!.position.x - 750...camera!.position.x + 750)
        meteor.position = CGPoint(x: x, y: 800)
        addChild(meteor)
        
        // 2. create action to move the meteor
        let moveAction = SKAction.moveBy(x: 700, y: -800, duration: 1)
        let sequenceAction = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        // 3. create node to play sound effect and action to modify the volume
//        let soundNode = SKAudioNode(fileNamed: "iceball.wav")
//        soundNode.autoplayLooped = false
//        meteor.addChild(soundNode)

//        let volumeAction = SKAction.changeVolume(to: 0.2, duration: 0)
//        soundNode.run(SKAction.group([volumeAction, SKAction.play()]) )
        
        // 4. make meteor node run the action
        meteor.run(sequenceAction)
    }
    
    func spawnMeteor() {
        // 1. create SKSpriteNode for meteor
        let meteor = SKSpriteNode(imageNamed: "meteor3")
        meteor.zPosition = 1
        meteor.setScale(0.2)
        meteor.color = UIColor.red
        meteor.colorBlendFactor = 0.8
        meteor.name = "meteor"
        
        let physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 2)
//        physicsBody.restitution = 0.5
        physicsBody.categoryBitMask = PhysicsCategory.meteor
        physicsBody.contactTestBitMask = PhysicsCategory.dino | PhysicsCategory.ground
        meteor.physicsBody = physicsBody
                
        let x = CGFloat.random(in: camera!.position.x - 750...camera!.position.x + 750)
        meteor.position = CGPoint(x: x, y: 800)
        addChild(meteor)
        
        // 2. create node to play sound effect and action to modify the volume
        let soundNode = SKAudioNode(fileNamed: "iceball.wav")
        soundNode.autoplayLooped = false
        meteor.addChild(soundNode)

        let volumeAction = SKAction.changeVolume(to: 0.2, duration: 0)
        soundNode.run(SKAction.group([volumeAction, SKAction.play()]) )
        
        // 4. make meteor node run the action
//        meteor.run(sequenceAction)
    }
    
    func setupSpawnAction() {
        
        // spawn background meteor
        let spawnBgMeteorAction = SKAction.run {
            self.spawnBackgroundMeteor()
        }
        
        let waitAction = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([spawnBgMeteorAction, waitAction])
        run(SKAction.repeatForever(sequence))
        
        // spawn meteor
        let spawnMeteorAction = SKAction.run {
            self.spawnMeteor()
        }
        
        let sequenceMeteor = SKAction.sequence([spawnMeteorAction, waitAction])
        run(SKAction.repeatForever(sequenceMeteor), withKey: "spawnMeteor")
//
//        run(SKAction.repeatForever(
//            SKAction.sequence([
//                spawnMeteorAction,
//                waitAction
//            ])
//        ))
        
    }
    
    func setupIdleAction() {
        var textures = [SKTexture]()
        for i in 1...10 {
            textures.append(SKTexture(imageNamed: "Idle (\(i))"))
        }
        idleAction = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
    }
    
    func setupRunningAction() {
        var textures = [SKTexture]()
        for i in 1...8 {
            textures.append(SKTexture(imageNamed: "Run\(i)"))
        }
        runningAction = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
    }
    
    func setupDyingAction() {
        dino.removeAllActions()
        removeAction(forKey: "spawnMeteor")
        
        var textures = [SKTexture]()
        for i in 1...8 {
            textures.append(SKTexture(imageNamed: "Dead (\(i))"))
        }
        dino.run(SKAction.animate(with: textures, timePerFrame: 0.1))
        
        // code untuk transisi
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = scaleMode
        
        let transition = SKTransition.fade(with: .red, duration: 1)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.run {
                self.view?.presentScene(gameOverScene, transition: transition)
                
                
//                self.gameSceneDelegate?.gameOver()
            }
        ]))
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            
        if contactMask == PhysicsCategory.meteor | PhysicsCategory.ground {
            
//            let node = contact.bodyA.node?.name == "meteor" ? contact.bodyA.node : contact.bodyB.node
            var node: SKNode? = nil
            if contact.bodyA.node?.name == "meteor" {
                node = contact.bodyA.node
            } else {
                node = contact.bodyB.node
            }
            node?.physicsBody?.contactTestBitMask = 0
            
            node?.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.removeFromParent()
            ]))
            
        } else if contactMask == PhysicsCategory.meteor | PhysicsCategory.dino {
            print("Lives \(lives)")
            if !isAlive {
                return
            }
            
            lives += -1
            
            if !isAlive {
                setupDyingAction()
            }
            
            var node: SKNode? = nil
            if contact.bodyA.node?.name == "meteor" {
                node = contact.bodyA.node
            } else {
                node = contact.bodyB.node
            }
            node?.run(SKAction.removeFromParent())
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
