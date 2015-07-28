//
//  AnimationController.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/21/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit

class AnimationController: NSObject {
    // All objects
    var view = UIView()
    var timerLabel = UILabel()
    var breakButton = UIButton()
    
    // Makes the break button disappear
    class func breakButtonDisappear(breakButton: UIButton) {
        UIView.animateWithDuration(0.4, animations: {
            breakButton.alpha = 0
            }, completion: { _ in
            breakButton.hidden = true
        })

    }
    
    // Re-appears the break button
    class func breakButtonAppear(breakButton: UIButton) {
        UIView.animateWithDuration(0.4, animations: {
            breakButton.hidden = false
            breakButton.alpha = 1
        })
    }
    
    // Makes a label fade in at start
    class func fadeIn(label: UILabel) {
        label.alpha = 0.0
        UIView.animateWithDuration(3.0, animations: {
            label.alpha = 1.0
        })
    }
    
    class func fadeInButton(button: UIButton) {
        button.alpha = 0.0
        UIView.animateWithDuration(3.0, animations: {
            button.alpha = 1.0
        })
    }
}
