//
//  ViewController.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/21/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var viewForLayer: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var mainTimer = TimerController()
    var mainClock = Clock()
    var mainGestureController = GestureController()
    var mainGradientController = GradientController()
    
    // Realm Properties
    let realm = Realm()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainTimer = TimerController(viewLabel: timerLabel)
        mainTimer.view = self.view
        mainTimer.breakButton = breakButton
        mainTimer.modeLabel = modeLabel
        mainTimer.pointsLabel = pointsLabel
        
        mainClock.timeLabel = clockLabel
        mainClock.start()
        
        mainGestureController.view = self.view
        mainGestureController.mainTimer = mainTimer
        
        breakButton.hidden = true
        breakButton.alpha = 0
        
        mainGradientController.view = self.view
        mainGradientController.layerView = viewForLayer
        mainGradientController.setupLayer()
        mainGradientController.changeGradient(3, time: 20.0)
        
        // Animations in the beginning
        AnimationController.fadeIn(pointsLabel)
        AnimationController.fadeIn(modeLabel)
        AnimationController.fadeInButton(startButton)
        AnimationController.fadeInButton(stopButton)
        
        // Realm setup
        setupFirstTime()
        let users = Realm().objects(User)
        let tempUser = users.first!
        println("The number is \(tempUser.number)")
        pointsLabel.text = "Points: \(tempUser.number)"
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
        mainGestureController.controlPan(sender)
    }
    
    
    
    
    
    // MARK: Realm Functions
    func userAddPoints(numberOfPoints: Int) {
        let users = Realm().objects(User)
        var tempUser = users.first!
        realm.write {
            tempUser.number += numberOfPoints
        }
        println("Added \(numberOfPoints)")
    }
    
    func userSubtractPoints(numberOfPoints: Int) {
        let users = Realm().objects(User)
        var tempUser = users.first!
        realm.write {
            tempUser.number -= numberOfPoints
            println(tempUser.number)
        }
        println("Subtracted \(numberOfPoints)")
    }
    
    func updatePointsLabel() {
//        let users = Realm().objects(User)
//        let tempUser = users.first!
//        println("The number is \(tempUser.number)")
//        pointsLabel.text = "Points: \(tempUser.number)"
    }
    
    
    // MARK: First Load Functions
    func setupFirstTime() {
        if isFirstTimeLaunch() {
            realm.write {
                self.realm.add(self.user)
                println("\(self.user) was added")
            }
        }
    }

    func isFirstTimeLaunch()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce") {
            println("App already launched")
            return false
        } else {
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            println("App launched first time")
            return true
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

