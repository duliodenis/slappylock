//
//  GameViewController.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/6/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import AVFoundation


class GameViewController: UIViewController, GameDelegate {
    
    var click: AVAudioPlayer!
        
    var continueMode: Bool?
    
    // For Social Sharing
    var screenShot: UIImage?
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initially hide the share button
        shareButton.hidden = true
        
        // iAd Initialization
        UIViewController.prepareInterstitialAds()
        interstitialPresentationPolicy = .Manual
        
        // Sound Initialization
        addSound()
        
        let scene = GameScene(size: view.bounds.size)
        
        // set the scene's game delegate
        scene.gameDelegate = self
        
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

    
    // MARK: Action Functions
    
    @IBAction func menuAction(sender: AnyObject) {
        click.play()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func shareAction(sender: AnyObject) {
        click.play()
        if let image = screenShot {
            share(image)
        }
    }
    
    
    // MARK: Utility Functions
    
    func snapPicture() {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 1.0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: false)
        screenShot = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    func share(image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // iPad Crash Fix: specify an anchor point for the presentation of the popover on iPad
        activityVC.popoverPresentationController?.sourceView = self.view
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    
    // MARK: Game Delegate Functions
    
    func gameStarted() {
        shareButton.hidden = true
    }
    
    func gameFinished(over: Bool) {
        snapPicture()
        shareButton.hidden = false
        
        if over { requestInterstitialAdPresentation() }
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
