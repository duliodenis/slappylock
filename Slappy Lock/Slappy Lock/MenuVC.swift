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
import GameKit


class MenuVC: UIViewController, GKGameCenterControllerDelegate {
    
    var click: AVAudioPlayer!
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
        
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
    
    
    @IBAction func leaderboardButton(sender: AnyObject) {
        click.play()
        showLeaderboard()
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
    
    
    // MARK: Game Center Functions
    
    func authenticateLocalPlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    
    func showLeaderboard() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
