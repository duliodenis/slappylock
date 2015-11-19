//
//  MenuVC.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/18/15.
//  Copyright © 2015 Dulio Denis. All rights reserved.
//

import UIKit
import iAd

class MenuVC: UIViewController {
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canDisplayBannerAds = true
    }
    
    
    // MARK: Button Actions
    
    @IBAction func playButton(sender: AnyObject) {
        let gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        gameVC.continueMode = false
        presentViewController(gameVC, animated: true, completion: nil)
    }

    @IBAction func continueButton(sender: AnyObject) {
        let gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        gameVC.continueMode = true
        presentViewController(gameVC, animated: true, completion: nil)
    }
}
