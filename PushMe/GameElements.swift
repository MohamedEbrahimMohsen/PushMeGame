//
//  GameElements.swift
//  PushMe
//
//  Created by Mohamed Mohsen on 4/30/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import SpriteKit

struct CollisionBitMask{
    static let Player:UInt32 = 0x00
    static let Obstacle:UInt32 = 0x01
}

enum ObstacleType:Int {
    case Small
    case Medium
    case Large
}

enum RowType:Int{
    case oneS
    case oneM
    case oneL
    case twoS
    case twoM
    case threeS
}

extension RowType {
    static var numOfElementsInside:Int{
        return 6 //#elements in the enum
    }
}

extension GameScene{
    func addPlayer(){
        player = SKSpriteNode(color: Constants.PlayerColor, size: CGSize(width: Constants.PlayerWidth, height: Constants.PlayerHeight))
        player.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * Constants.MargineSpaceFromButtom)
        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle
        
        player2 = SKSpriteNode(color: Constants.PlayerColor, size: CGSize(width: Constants.PlayerWidth, height: Constants.PlayerHeight))
        player2.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * Constants.MargineSpaceFromButtom)
        player2.name = "PLAYER"
        player2.physicsBody?.isDynamic = false
        player2.physicsBody = SKPhysicsBody(rectangleOf: player2.size)
        player2.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player2.physicsBody?.collisionBitMask = 0
        player2.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle

        addChild(player)
        addChild(player2)
        initialPlayerPosition = player.position
    }
    
    func addObstacle(with type: ObstacleType) -> SKSpriteNode{
       
        let obstacle = SKSpriteNode(color: Constants.ObstacleColor, size: CGSize(width: 0, height: self.frame.height * Constants.ObstaclePercentageHeight))
        obstacle.position = CGPoint(x: self.frame.width / 2, y: self.frame.height + (self.frame.height * Constants.ObstaclePercentageHeight))
        //pos.Height = total screen height + the obstacle height
        obstacle.name = "OBSTACLE"
        obstacle.physicsBody?.isDynamic = false

        switch type {
        case .Small:
            obstacle.size.width = self.frame.width * Constants.ObstacleSmallPercentageWidth
        case .Medium:
            obstacle.size.width = self.frame.width * Constants.ObstacleMediumPercentageWidth
        case .Large:
            obstacle.size.width = self.frame.width * Constants.ObstacleLargePercentageWidth
        }
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle
        obstacle.physicsBody?.collisionBitMask = 0
        //obstacle.physicsBody?.contactTestBitMask = CollisionBitMask.Player  --- don't need this 'cause player already will collide

        return obstacle
    }
    
    func addMovement(for obstacle:SKSpriteNode){
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: obstacle.position.x, y: -obstacle.position.y), duration: TimeInterval(Constants.ObstacleSpeed[level.rawValue]))) //-----
        actionArray.append(SKAction.removeFromParent())
        obstacle.run(SKAction.sequence(actionArray))
    }
    
    func addRow(with type:RowType){
        switch type {
        case .oneS:
            let obstacle = addObstacle(with: .Small)
            addMovement(for: obstacle)
            addChild(obstacle)
        case .oneM:
            let obstacle = addObstacle(with: .Medium)
            addMovement(for: obstacle)
            addChild(obstacle)
        case .oneL:
            let obstacle = addObstacle(with: .Large)
            addMovement(for: obstacle)
            addChild(obstacle)
        case .twoS:
            let obstacle  = addObstacle(with: .Small)
            let obstacle2 = addObstacle(with: .Small)
            let leadingSpace = Constants.LeadingSpace[Constants.LeadingSpace.count.arc4random]
            
            obstacle.position = CGPoint(x: obstacle.size.width + leadingSpace, y: obstacle.position.y)
            obstacle2.position = CGPoint(x: self.size.width - obstacle2.size.width - leadingSpace, y: obstacle2.position.y) //Top Middle

            addMovement(for: obstacle)
            addMovement(for: obstacle2)

            addChild(obstacle)
            addChild(obstacle2)

        case .twoM:
            let obstacle  = addObstacle(with: .Medium)
            let obstacle2 = addObstacle(with: .Medium)
            let leadingSpace = Constants.LeadingSpace[Constants.LeadingSpace.count.arc4random]
            
            obstacle.position = CGPoint(x: obstacle.size.width/2 + leadingSpace, y: obstacle.position.y)
            obstacle2.position = CGPoint(x: self.size.width - obstacle.size.width/2 - leadingSpace , y: obstacle2.position.y)
            
            addMovement(for: obstacle)
            addMovement(for: obstacle2)
            
            addChild(obstacle)
            addChild(obstacle2)
        case .threeS:
            let obstacle  = addObstacle(with: .Small)
            let obstacle2 = addObstacle(with: .Small)
            let obstacle3 = addObstacle(with: .Small)
            let leadingSpace = Constants.LeadingSpace[(Constants.LeadingSpace.count - 2).arc4random] //get only 0 and 50
            
            obstacle.position = CGPoint(x: obstacle.size.width/2 + leadingSpace, y: obstacle.position.y) //Left
            obstacle2.position = CGPoint(x: self.size.width / 2 , y: obstacle2.position.y) //Middle
            obstacle3.position = CGPoint(x: self.size.width - obstacle.size.width/2 - leadingSpace , y: obstacle2.position.y) //Right

            addMovement(for: obstacle)
            addMovement(for: obstacle2)
            addMovement(for: obstacle3)

            addChild(obstacle)
            addChild(obstacle2)
            addChild(obstacle3)

        }
    }
}

enum Level:Int{
    case LevelOne
    case LevelTwo
    case LevelThree
    case LevelFour
    case LevelFive
    case LevelSix
}

struct Constants{
    static let MargineSpaceFromButtom: CGFloat = 0.1
    
    static let PlayerWidth:CGFloat = 50
    static let PlayerHeight:CGFloat = 50
    static let PlayerColor: UIColor = UIColor.red
    
    static let ObstacleSmallPercentageWidth:CGFloat = 0.2
    static let ObstacleMediumPercentageWidth:CGFloat = 0.35
    static let ObstacleLargePercentageWidth:CGFloat = 0.75
    static let ObstaclePercentageHeight:CGFloat = 0.016
    static let ObstacleColor: UIColor = UIColor.white
    static let StayAwayFromTop: CGFloat = 30.0 //how much spaces should the obstacle stay a way from the top when we create it
    static let ObstacleSpeed:[Int] = [20, 16, 12, 8, 4, 2]
    
    static let LeadingSpace:[CGFloat] = [0, PlayerWidth*1, PlayerWidth*2, PlayerWidth*3]
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


































