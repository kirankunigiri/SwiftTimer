//
//  TimerController.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/21/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TimerController: NSObject {
    
    //Properties
    
    // Will run every 0.1 seconds
    var timer = NSTimer()
    let realm = Realm()
    // The time when the timer started
    var startTime = NSTimeInterval()
    
    // Required objects to set from ViewController
    var label = UILabel()
    var pointsLabel = UILabel()
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
    var kModeWorkText = "Work Mode"
    var kModeBreakText = "Break Mode"
    
    override init() {
        super.init()
    }
    
    // To create a timer with the label to update
    init(viewLabel: UILabel) {
        super.init()
        
        // Set the label and its text to default
        label = viewLabel
        updateLabel()
        label.text = "Start"
        modeLabel.text = kWorkText
        
        label.alpha = 0.0
        AnimationController.fadeIn(label)
        
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
        if !timer.valid && totalTime != 0 {
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
            AnimationController.breakButtonDisappear(breakButton)
            println("\(state)")
        }
    }
    
    // Main function used to stop the timer, used in the timerfinished() function
    func stop() {
        // Only stop it if it is currently valid (running)
        if timer.valid {
            // Invalidate the timer and reset it to 0
            timer.invalidate()
            resetTimer()
            // Update the state to work select state
            label.text = kWorkText
            if state == stateBreak {
                state = stateSelectCountdown
                modeLabel.text = kModeWorkText

            }
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
    
    // Changes the total time left
    func setTimeLeft(timeLeft: NSTimeInterval) {
        totalTime = timeLeft
        resetDisplay()
    }
    
    // Resets the timer to the default 0, used by the stop() function
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
    
    // Updates the label with the newest values
    private func updateLabel() {
        if hours > 0 {
            label.text = "\(strHours):\(strMinutes):\(strSeconds)"
        } else {
            label.text = "\(strMinutes):\(strSeconds)"
        }
    }
    
    // This function is called every time the timer finshes
    // It switches the states and hides button
    // Later it will be used to add points and update the UI
    private func timerFinished() {
        if state == stateCountdown {
            userAddPoints(Int(totalTime))
            AnimationController.breakButtonAppear(breakButton)
        } else if state == stateBreak {
            AnimationController.breakButtonDisappear(breakButton)
            breakButton.selected = false
            state = stateSelectCountdown
            modeLabel.text = kWorkText
        }
        
        self.stop()
    }
    
    // MARK: Realm Functions
    func userAddPoints(numberOfPoints: Int) {
        let users = Realm().objects(User)
        var tempUser = users.first!
        realm.write {
            tempUser.number += numberOfPoints
        }
        pointsLabel.text = "Points: \(tempUser.number)"
    }
    
    func userSubtractPoints(numberOfPoints: Int) {
        let users = Realm().objects(User)
        var tempUser = users.first!
        realm.write {
            tempUser.number -= numberOfPoints
        }
        pointsLabel.text = "Points: \(tempUser.number)"
    }
    
}

