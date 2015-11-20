//
//  MenuVC.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/18/15.
//  Copyright © 2015 Dulio Denis. All rights reserved.
//

import UIKit
import iAd
import AVFoundation


class MenuVC: UIViewController {
    
    var click: AVAudioPlayer!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSound()
        canDisplayBannerAds = true
    }
    
    
    // MARK: Button Actions
    
    @IBAction func playButton(sender: AnyObject) {
        click.play()
        let gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        gameVC.continueMode = false
        presentViewController(gameVC, animated: true, completion: nil)
    }

    @IBAction func continueButton(sender: AnyObject) {
        click.play()
        let gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        gameVC.continueMode = true
        presentViewController(gameVC, animated: true, completion: nil)
    }
    
    
    // MARK: AVAudioPlayer Utility Function
    
    func addSound() {
        // AudioPlayer for Button Click
        do {
            try click = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("click", ofType: "wav")!))
            click.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
