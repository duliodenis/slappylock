//
//  GameScene.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/6/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import SpriteKit
import AVFoundation


// The Game Delegate Protocol
protocol GameDelegate {
    func gameStarted()
    func gameFinished()
}


class GameScene: SKScene {
    
    var gameDelegate: GameDelegate?
    
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
    
    // UI
    var levelLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    
    // Sound Effects
    var click: AVAudioPlayer!
    var win: AVAudioPlayer!
    var fail: AVAudioPlayer!
    var pop: AVAudioPlayer!
    
    // Game Mode
    var continueMode = Bool()
    var maxLevel = NSUserDefaults.standardUserDefaults().integerForKey("maxLevel")
    
    
    //MARK: View Lifecycle
    
    override func didMoveToView(view: SKView) {
        if continueMode {
            level = maxLevel
        }
        
        layoutGame()
    }
    
    
    func layoutGame() {
        backgroundColor = SKColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        
        if level > maxLevel {
            NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "maxLevel")
        }
        
        path = makePath(zeroAngle)
        
        lock = SKShapeNode(path: path.CGPath)
        lock.strokeColor = SKColor(red: 46.0/255.0, green: 135.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        lock.lineWidth = 40.0
        addChild(lock)
        
        needle = SKShapeNode(rectOfSize: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.blackColor()
        needle.position = CGPoint(x: frame.width/2, y: frame.height/2 + 120.0)
        needle.zRotation = 3.14 / 2
        needle.zPosition = 2.0
        addChild(needle)
        addDot()
        addLabels()
        addSound()
        userInteractionEnabled = true
    }
    
    
    func gameOver(over: Bool) {
        needle.removeFromParent()
        userInteractionEnabled = false
        
        // Flash Indication
        var color: UIColor
        if over {   // flash gray
            color = UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0)
            scoreLabel.text = "Missed"
            fail.play()
        } else {    // flash green
            color = UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
            scoreLabel.text = "Complete"
            win.play()
        }
        let startFlash  = SKAction.colorizeWithColor(color, colorBlendFactor: 1.0, duration: 0.25)
        let endFlash = SKAction.waitForDuration(0.5)
        
        scene?.runAction(SKAction.sequence([startFlash, endFlash]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            if !over { self.level++ }
            self.layoutGame()
            self.gameDelegate?.gameFinished()
        })
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !started {
            calculateScore()
            clockwise = true
            runClockwise()
            started = true
        } else {
            dotTouched()
        }
    }

   
    override func update(currentTime: CFTimeInterval) {
        if started {
            gameDelegate?.gameStarted()
            
            if (CGRectIntersectsRect(needle.frame, dot.frame)) {
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
        //dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.fillColor = SKColor(red: 210.0/255.0, green:37.0/255.0, blue: 37.0/255.0, alpha: 1.0)
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
            pop.play()
            touched = false
            
            // Increment dots, calculate score and check to see if user has met level
            dots++
            calculateScore()
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
    
    
    // MARK: UI Functions
    
    func addLabels() {
        levelLabel = SKLabelNode(fontNamed: "Bender-Inline")
        levelLabel.position = CGPoint(x: frame.width/2, y: frame.height/2 + frame.height/3)
        levelLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        levelLabel.text = "Level \(level)"
        
        scoreLabel = SKLabelNode(fontNamed: "Bender-Inline")
        scoreLabel.position = CGPoint(x: frame.width/2, y: frame.height/2)
        scoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        scoreLabel.text = "Tap to start"
        
        addChild(levelLabel)
        addChild(scoreLabel)
    }
    
    func calculateScore() {
        scoreLabel.text = "\(level - dots)"
    }
    
    
    // MARK: Audio Function
    
    func addSound() {
        do {
            try click = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("click", ofType: "wav")!))
            try win = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("win", ofType: "wav")!))
            try fail = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fail", ofType: "wav")!))
            try pop = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pop", ofType: "wav")!))
            click.prepareToPlay()
            win.prepareToPlay()
            fail.prepareToPlay()
            pop.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
