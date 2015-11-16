//
//  GameScene.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/6/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var lock = SKShapeNode()
    var needle = SKShapeNode()
    var path = UIBezierPath()
    let zeroAngle: CGFloat = 0.0
    
    var started = false
    
    
    //MARK: View Lifecycle
    
    override func didMoveToView(view: SKView) {
        layoutGame()
    }
    
    
    func layoutGame() {
        backgroundColor = SKColor.whiteColor()
        
        path = makePath(zeroAngle)
        
        lock = SKShapeNode(path: path.CGPath)
        lock.strokeColor = SKColor.grayColor()
        lock.lineWidth = 40.0
        self.addChild(lock)
        
        needle = SKShapeNode(rectOfSize: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.whiteColor()
        needle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120.0)
        needle.zRotation = 3.14 / 2
        needle.zPosition = 2.0
        self.addChild(needle)
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !started {
            runClockwise()
            started = true
        }
    }

   
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    
    // MARK: Movement Methods
    
    func runClockwise() {
        let dx = needle.position.x - frame.width / 2
        let dy = needle.position.y - frame.height / 2
        
        let radian = atan2(dy, dx)
        
        path = makePath(radian)
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        needle.runAction(SKAction.repeatActionForever(run).reversedAction())
    }
    
    
    // MARK: UIBezierPath Convenience Method
    
    func makePath(angle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                            radius: 120,
                            startAngle: angle,
                            endAngle: angle + CGFloat(M_PI * 2),
                            clockwise: true)
    }
}
