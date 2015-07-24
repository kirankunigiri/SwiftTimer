//
//  GestureController.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/23/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit

class GestureController: NSObject {
    
    // Required init properties
    var mainTimer = TimerController()
    var view = UIView()
    
    // Constants
    var lastRecognizedInterval = CGPoint()
    var kPanIntervalDistance : CGFloat = 30
    var kPanIntervalSeconds = NSTimeInterval(1)
    
    func controlPan(sender: UIPanGestureRecognizer) {
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
}