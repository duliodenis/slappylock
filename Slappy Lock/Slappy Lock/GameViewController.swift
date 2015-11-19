//
//  GameViewController.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/6/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var continueMode: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        
        // Configure the view.
        let skView = self.view as! SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        if let continueIsTrue = continueMode {
            scene.continueMode = continueIsTrue
        }
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    @IBAction func MenuButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
