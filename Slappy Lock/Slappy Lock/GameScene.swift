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
    var dot = SKShapeNode()
    
    var path = UIBezierPath()
    let zeroAngle: CGFloat = 0.0
    
    var clockwise = Bool()
    
    var started = false
    var touched = false
    
    // Level Support
    var level = 1
    var dots  = 0
    
    
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
        addChild(lock)
        
        needle = SKShapeNode(rectOfSize: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.whiteColor()
        needle.position = CGPoint(x: frame.width/2, y: frame.height/2 + 120.0)
        needle.zRotation = 3.14 / 2
        needle.zPosition = 2.0
        addChild(needle)
        addDot()
    }
    
    
    func gameOver(over: Bool) {
        needle.removeFromParent()
        
        // Flash Indication
        let startFlash: SKAction
        if over {   // flash red
            startFlash  = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.25)
        } else {    // flash green
            startFlash  = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0.25)
        }
        let endFlash = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.25)
        
        scene?.runAction(SKAction.sequence([startFlash, endFlash]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            if !over { self.level++ }
            self.layoutGame()
        })
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !started {
            clockwise = true
            runClockwise()
            started = true
        } else {
            dotTouched()
        }
    }

   
    override func update(currentTime: CFTimeInterval) {
        if started {
            if needle.intersectsNode(dot) {
                touched = true
            } else {
                if touched {
                    started = false
                    touched = false
                    gameOver(true)
                }
            }
        }
    }
    
    
    // MARK: Movement Methods
    
    func runClockwise() {
        path = makePath(getRadian())
        
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        if clockwise {
            needle.runAction(SKAction.repeatActionForever(run).reversedAction())
        } else {
            needle.runAction(SKAction.repeatActionForever(run))
        }
    }
    
    
    func addDot() {
        dot = SKShapeNode(circleOfRadius: 15.0)
        dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clearColor()
        
        let radian = getRadian()
        let tempAngle: CGFloat
        
        if clockwise {
            tempAngle = CGFloat.random(radian + 1.0, max: radian + 2.5)
        } else {
            tempAngle = CGFloat.random(radian - 1.0, max: radian - 2.5)
        }
        
        let tempPath = makePath(tempAngle)
        dot.position = tempPath.currentPoint
        addChild(dot)
    }
    
    
    func dotTouched() {
        if touched {
            touched = false
            
            // Increment dots and check to see if user has met level
            dots++
            if dots >= level {
                started = false // reset
                gameOver(false) // level completed but game is not over
                return          // return to continue
            }
            
            dot.removeFromParent()
            addDot()
            if clockwise {
                clockwise = false
                runClockwise()
            } else {
                clockwise = true
                runClockwise()
            }
        } else {
            started = false
            touched = false
            gameOver(true)
        }
    }
    
    // MARK: UIBezierPath and Radian Convenience Functions
    
    func makePath(angle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                            radius: 120,
                            startAngle: angle,
                            endAngle: angle + CGFloat(M_PI * 2),
                            clockwise: true)
    }
    
    
    func getRadian() -> CGFloat {
        let dx = needle.position.x - frame.width / 2
        let dy = needle.position.y - frame.height / 2
        
        return atan2(dy, dx)
    }
}
