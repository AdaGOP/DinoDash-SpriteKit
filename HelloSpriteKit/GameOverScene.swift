//
//  GameOverScene.swift
//  HelloSpriteKit
//
//  Created by Benyamin on 6/11/20.
//  Copyright © 2020 Benyamin. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let upperLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
        upperLabel.text = "Game Over"
//        upperLabel.position = self.view!.center
        upperLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        upperLabel.fontSize = 100
        addChild(upperLabel)
        
        let lowerLabel = SKLabelNode(text: "Press Any Key To Return To Main Menu")
        lowerLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) - 150)
        lowerLabel.fontSize = 50
        addChild(lowerLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let scene = SKScene(fileNamed: "MainMenuScene")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
        
    }
    
}
