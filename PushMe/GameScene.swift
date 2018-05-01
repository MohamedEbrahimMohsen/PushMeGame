//
//  GameScene.swift
//  PushMe
//
//  Created by Mohamed Mohsen on 4/30/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var player2: SKSpriteNode!
    var initialPlayerPosition: CGPoint!
    var level: Level! = Level.LevelFour
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        addPlayer()
        addRow(with: .threeS)

    }
    
    func addRandomRow(){
        let randomNumber = RowType.numOfElementsInside.arc4random
        addRow(with: RowType(rawValue: randomNumber)!)
        
    }
    
    var lastUpdatedTimeInterval: TimeInterval? = nil
    var grossTimeItervals: Double! = 0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdatedTimeInterval == nil{lastUpdatedTimeInterval = currentTime}
        grossTimeItervals = grossTimeItervals + (currentTime - lastUpdatedTimeInterval!)
        if grossTimeItervals > Double(1.0 / Double((Double(level.rawValue) + 3.0) / 3.0)){
            addRandomRow()
            grossTimeItervals = 0
        }
        lastUpdatedTimeInterval = currentTime
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "PLAYER"{
            //print("GAME OVER")
            showGameOver()
        }
    }
    
    func showGameOver(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene, transition: transition)

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force / maximumPossibleForce
            
            player.position.x  = (self.size.width/2) - normalizedForce * (self.size.width/2)
            player2.position.x = (self.size.width/2) + normalizedForce * (self.size.width/2)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
    }
    
    func resetPlayerPosition(){
        player.position = initialPlayerPosition
        player2.position = initialPlayerPosition
    }
}




























