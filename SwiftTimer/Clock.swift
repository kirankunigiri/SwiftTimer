//
//  Clock.swift
//  CALayerPlayground
//
//  Created by Kiran Kunigiri on 7/17/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit

class Clock : NSObject {
    
    // Properties
    var dateFormatter = NSDateFormatter()
    var timeLabel = UILabel()
    
    // Returns the current time in a string
    func getTimeString() -> String {
        dateFormatter.timeStyle = .ShortStyle
        return "\(dateFormatter.stringFromDate(NSDate()))"
    }
    
    // Starts the clock by making it visible starting the timer to update it
    func start() {
        updateTimer()
        timeLabel.alpha = 0.0
        UIView.animateWithDuration(3.0, animations: {
            self.timeLabel.alpha = 1.0
        })
        var updateTime = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    // Updates the timer by getting the time string and updating the label
    func updateTimer() {
        var timeString = getTimeString()
        self.timeLabel.text = timeString
    }
}