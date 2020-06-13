//
//  MainMenuScene.swift
//  HelloSpriteKit
//
//  Created by Benyamin on 6/11/20.
//  Copyright © 2020 Benyamin. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var gameSceneDelegate: GameSceneDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        guard let touch = touches.first else { return }
        
//        let node = nodes(at: touch.location(in: self)).first
        
        let buttonNode = childNode(withName: "startButton")
        
        if buttonNode!.frame.contains(touch.location(in: self)) {
            let gameScene = SKScene(fileNamed: "GameScene")
            
            if let gameScene = gameScene as? GameScene {
                gameScene.gameSceneDelegate = gameSceneDelegate
            }
            
            gameScene?.scaleMode = scaleMode
            view?.presentScene(gameScene)
        }
    }
}
