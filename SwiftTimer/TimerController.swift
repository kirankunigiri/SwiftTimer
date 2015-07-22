//
//  TimerController.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/21/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit

class TimerController: NSObject {
    
    //Properties
    
    // Will run every 0.1 seconds
    var timer = NSTimer()
    // The time when the timer started
    var startTime = NSTimeInterval()
    
    // The UILabel we will have to update, along with an optional view if needed
    var label = UILabel()
    var breakButton = UIButton()
    var modeLabel = UILabel()
    var view = UIView()
    
    // Properties of the label string
    var strHours = "0"
    var strMinutes = "00"
    var strSeconds = "00"
    
    // The amount of time in the countdown
    var totalTime: NSTimeInterval = 0
    
    // Properties of actual values
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    // States
    var stateSelectCountdown = 0
    var stateCountdown = 1
    var stateSelectBreak = 2
    var stateBreak = 3
    var state = 0
    
    // Constant text strings
    var kWorkText = "Start working!"
    var kBreakText = "Want to take a break?"
    
    override init() {
        
    }
    
    // To create a timer with the label to update
    init(viewLabel: UILabel) {
        super.init()
        
        // Set the label and its text to default
        label = viewLabel
        updateLabel()
        label.text = "Start"
        
        state = stateSelectCountdown
    }
    
    // MARK: Main Update Function
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //Set the elapsed time to the amount of time left in the timer
        var timeLeft = totalTime - elapsedTime
        
        // Runs when the timer is over, otherwise continue to update the timer
        if timeLeft < 1 {
            timerFinished()
        } else {
            //calculate the hours in elapsed time.
            hours = Int(timeLeft / 3600.0)
            timeLeft -= (NSTimeInterval(hours) * 3600)
            //calculate the minutes in elapsed time.
            minutes = Int(timeLeft / 60.0)
            timeLeft -= (NSTimeInterval(minutes) * 60)
            //calculate the seconds in elapsed time.
            seconds = Int(timeLeft)
            timeLeft -= NSTimeInterval(seconds)
            //add the leading zero for minutes, seconds and millseconds and store them as string constants
            strHours = String(format: "%01d", hours)
            strMinutes = String(format: "%02d", minutes)
            strSeconds = String(format: "%02d", seconds)
            //concatenate minuets, seconds and milliseconds as assign it to the UILabel
            updateLabel()
        }
    }
    
    // MARK: Start/Stop Functions
    func start() {
        // Check to make sure the timer has not started yet and the time is greater than 0
        if !timer.valid && totalTime != 0{
            // Create a timer and start it
            let aSelector: Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            // Update the state to timing modes
            if state == stateSelectCountdown {
                state = stateCountdown
            } else if state == stateSelectBreak {
                state = stateBreak
            }
        }
    }
    
    func stop() {
        // Only stop it if it is currently valid (running)
        if timer.valid {
            // Invalidate the timer and reset it to 0
            timer.invalidate()
            resetTimer()
            // Update the state to work select state
            label.text = kWorkText
        }
    }
    
    // MARK: Get Value Functions
    
    // Gets the time remaining in an NSTimeInterval
    func getTimeLeft() -> NSTimeInterval {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        //Set the elapsed time to the amount of time left in the timer
        var timeLeft = totalTime - elapsedTime
        return timeLeft
    }
    
    // Gets the number of seconds completed in am NTimeInterval
    func getTimeComplete() -> NSTimeInterval {
        var timeLeft = getTimeLeft()
        var timeComplete = totalTime - timeLeft
        return timeComplete
    }
    
    // Returns the percent of the timer completed with a decimal
    func getPercentageCompleted() -> Double {
        var timeLeft = getTimeLeft()
        var timeComplete = totalTime - timeLeft
        var percent = timeComplete/totalTime
        
        return percent
    }
    
    // MARK: Set/Reset Functions
    
    // Same as the updateTimer, but is used to access outside this class
    // Uses totalTime to update display instead of the time left in updateTime()
    func resetDisplay() {
        var timeLeft = totalTime
        //calculate the hours in elapsed time.
        hours = Int(timeLeft / 3600.0)
        timeLeft -= (NSTimeInterval(hours) * 3600)
        //calculate the minutes in elapsed time.
        minutes = Int(timeLeft / 60.0)
        timeLeft -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        seconds = Int(timeLeft)
        timeLeft -= NSTimeInterval(seconds)
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        strHours = String(format: "%01d", hours)
        strMinutes = String(format: "%02d", minutes)
        strSeconds = String(format: "%02d", seconds)
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        updateLabel()
    }
    
    func setTimeLeft(timeLeft: NSTimeInterval) {
        totalTime = timeLeft
        resetDisplay()
    }
    
    func resetTimer() {
        totalTime = NSTimeInterval(0)
        resetDisplay()
    }
    
    func resetTimerWithNewTime(newTotalTime: NSTimeInterval) {
        self.totalTime = newTotalTime
        startTime = NSDate.timeIntervalSinceReferenceDate()
        var strHours = "0"
        var strMinutes = "00"
        var strSeconds = "00"
        var hours = 0
        var minutes = 0
        var seconds = 0
        updateLabel()
    }
    
    // MARK: Private Update Functions
    private func updateLabel() {
        if hours > 0 {
            label.text = "\(strHours):\(strMinutes):\(strSeconds)"
        } else {
            label.text = "\(strMinutes):\(strSeconds)"
        }
    }
    
    private func timerFinished() {
        if state == stateCountdown {
            AnimationController.breakButtonAppear(breakButton)
        } else if state == stateBreak {
            AnimationController.breakButtonDisappear(breakButton)
            breakButton.selected = false
            state = stateSelectCountdown
        }
        
        self.stop()
    }
    
}

