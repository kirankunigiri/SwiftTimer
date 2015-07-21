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
    var mainTimer = TimerController()
    var recognizer = UIPanGestureRecognizer()
    var lastRecognizedInterval = CGPoint()
    var kPanIntervalDistance : CGFloat = 30
    var kPanIntervalSeconds = NSTimeInterval(300)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainTimer = TimerController(viewLabel: timerLabel)
        recognizer = UIPanGestureRecognizer(target: self, action: "screenSwiped:")
        self.view.addGestureRecognizer(recognizer)
        
        mainTimer.setTimeLeft(NSTimeInterval(0))
        mainTimer.view = self.view
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
    
    // Allows user to swipe the screen to set the timer
    @IBAction func screenSwiped(sender: UIPanGestureRecognizer) {
        // Checks to make sure the timer is invalid and not yet running
        if !mainTimer.timer.valid {
            // Get total distance traveled in current pan
            var thisInterval = recognizer.translationInView(self.view)
            
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
    
    
    
}

