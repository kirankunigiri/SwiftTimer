//
//  ViewController.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/21/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var modeLabel: UILabel!
    var mainTimer = TimerController()
    var lastRecognizedInterval = CGPoint()
    var kPanIntervalDistance : CGFloat = 30
    var kPanIntervalSeconds = NSTimeInterval(1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainTimer = TimerController(viewLabel: timerLabel)
        
        mainTimer.view = self.view
        mainTimer.breakButton = breakButton
        mainTimer.modeLabel = modeLabel
        
        breakButton.hidden = true
        breakButton.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(sender: UIButton) {
        mainTimer.start()
    }
    
    @IBAction func stop(sender: UIButton) {
        mainTimer.stop()
    }
    
    @IBAction func breakButtonPressed(sender: UIButton) {
        
        // If the sender is being turned on, set to break mode
        if !sender.selected {
            mainTimer.state = mainTimer.stateSelectBreak
            modeLabel.text = "Break mode"
            sender.selected = true
        } else {
            mainTimer.state = mainTimer.stateSelectCountdown
            modeLabel.text = "Work mode"
            sender.selected = false
        }
    }

    
    // Allows user to swipe the screen to set the timer
    @IBAction func screenSwiped(sender: UIPanGestureRecognizer) {
        // Checks to make sure the timer is invalid and not yet running
        if !mainTimer.timer.valid {
            // Get total distance traveled in current pan
            var thisInterval = sender.translationInView(self.view)
            
            // If the total distance minus the last distance point is greater than the minimum pan distance, pan the timer values
            if lastRecognizedInterval.y - thisInterval.y > kPanIntervalDistance {
                // Update the last distance point
                lastRecognizedInterval = thisInterval;
                // Update the timer value and display
                mainTimer.totalTime += kPanIntervalSeconds
                mainTimer.resetDisplay()
            } else if -lastRecognizedInterval.y + thisInterval.y > kPanIntervalDistance {
                // Update the last distance point
                lastRecognizedInterval = thisInterval;
                // Update the timer value and display, and set it to zero in case it becomes negative
                mainTimer.totalTime -= kPanIntervalSeconds
                if mainTimer.totalTime < 0 {
                    mainTimer.totalTime = 0
                }
                mainTimer.resetDisplay()
            }
            // Reset the last distance point back to zero if all fingers lift
            if sender.state == UIGestureRecognizerState.Ended {
                lastRecognizedInterval = CGPoint()
            }
        }
    }
    
    
    
    
    
    
    
    
    // Animation functions
    func animateChangeText(labelToAnimate: UILabel, color: UIColor) {
        UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            
            }, completion: {
                (finished: Bool) -> () in
                
                UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    
                    labelToAnimate.textColor = color
                    
                    }, completion: {
                        (finished: Bool) -> () in
                })
        })
    }
    
    // Creates a random UIColor
    func getRandomColor() -> UIColor {
        var randomRed: CGFloat = CGFloat(drand48())
        var randomGreen: CGFloat = CGFloat(drand48())
        var randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)
    }
    
    
    
    
}

