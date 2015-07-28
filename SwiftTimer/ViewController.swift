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
    
    // MARK: Properties
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var viewForLayer: UIView!
    
    // Label Properties
    var startButton = UIButton()
    var mainImage = UIImageView(image: UIImage(named: "Sun1"))
    var timerLabel = UILabel()
    var greetingLabel = UILabel()
    var clockLabel = UILabel()
    var levelLabel = UILabel()
    var modeLabel = UILabel()

    // Object properties
    var mainTimer = TimerController()
    var mainClock = Clock()
    var mainGestureController = GestureController()
    var mainGradientController = GradientController()
    
    // Realm Properties
    let realm = Realm()
    var user = User()
    
    // MARK: Setup Functions
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
        
        // Animations in the beginning
        AnimationController.fadeIn(pointsLabel)
        AnimationController.fadeIn(modeLabel)
        AnimationController.fadeInButton(startButton)
        
        //NSNotifications for event leaving observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appLeave", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnter", name: UIApplicationDidBecomeActiveNotification, object: nil)

        // Realm setup
        setupFirstTime()
        updatePointsLabel()
        
        setupPosition()
    }
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    
    func setupPosition() {
        
        // Background Gradient
        
        var centerX = self.view.frame.width/2
        var centerY = self.view.frame.height/2
        var sunCenter = self.view.frame.height * 0.6
        
        // Sun image
        startButton.setImage(UIImage(named: "Sun1"), forState: UIControlState.Normal)
        startButton.addTarget(self, action: "start", forControlEvents: UIControlEvents.TouchUpInside)
        startButton.adjustsImageWhenHighlighted = false

        var imageSize = self.view.frame.width * 0.8
        var imageFrame = CGRectMake(centerX - imageSize/2, sunCenter - imageSize/2, imageSize, imageSize)
        self.startButton.frame = imageFrame
        startButton.backgroundColor = UIColor.clearColor()
        self.view.addSubview(startButton)
        
        // Timer Label
        var fontSize = 0.22 * imageSize
        var timerFrame = CGRectMake(centerX, sunCenter, imageSize, imageSize)
        timerLabel.frame = imageFrame
        timerLabel.text = "24:36"
        timerLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(timerLabel)
        
        // Greeting label
        fontSize = 0.09 * self.view.frame.width
        var sunGap = CGFloat(20)
        var greetingFrame = CGRectMake(0, sunCenter - imageSize/2 - sunGap,  self.view.frame.width, fontSize * 1.2)
        greetingLabel.frame = greetingFrame
        greetingLabel.text = "Good Morning"
        greetingLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)
        greetingLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(greetingLabel)
        
        // Clock Label
        fontSize = 0.08 * self.view.frame.width
        var clockFrame = CGRectMake(0, greetingFrame.origin.y - greetingFrame.height * 0.6,  self.view.frame.width, fontSize)
        clockLabel.frame = clockFrame
        clockLabel.text = "9:37 AM"
        clockLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)
        clockLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(clockLabel)
        
        // Level Label
        fontSize = 0.06 * self.view.frame.width
        var marginX = CGFloat(10)
        var marginY = CGFloat(10)
        var levelFrame = CGRectMake(0, marginY,  self.view.frame.width - marginX, fontSize * 1.2)
        levelLabel.frame = levelFrame
        levelLabel.text = "Level 22: Task Master"
        levelLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)
        levelLabel.textAlignment = NSTextAlignment.Right
        self.view.addSubview(levelLabel)
        
        // Mode Label
        fontSize = 0.06 * self.view.frame.width
        marginX = CGFloat(10)
        marginY = CGFloat(10)
        var modeFrame = CGRectMake(0, marginY + levelFrame.height,  self.view.frame.width - marginX, fontSize * 1.2)
        modeLabel.frame = modeFrame
        modeLabel.text = "Work Mode"
        modeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)
        modeLabel.textAlignment = NSTextAlignment.Right
        self.view.addSubview(modeLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Outlet/Gesture Functions
    func start() {
        mainTimer.start()
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
        let users = Realm().objects(User)
        let tempUser = users.first!
        println("The number is \(tempUser.number)")
        pointsLabel.text = "Points: \(tempUser.number)"
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

    func isFirstTimeLaunch() -> Bool{
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
    
    
    
    
    // MARK: App leave/enter functions
    
    // Runs when the user leaves the app to background
    func appLeave() {
        // If the user is supposed to be working, penalize them and update UI
        if mainTimer.state == mainTimer.stateCountdown {
            userSubtractPoints(10)
            updatePointsLabel()
            println("Background mode with penalty")
        }
        
        println("Current state after leaving is \(mainTimer.state)")
    }
    
    // Runs whenever the app is opened from background
    func appEnter() {
        breakTooLong()
    }
    
    // Code runs when break is too long
    func breakTooLong() {
        if mainTimer.breakOver {
            println("You had a too long break!")
            mainTimer.breakOver = false
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

