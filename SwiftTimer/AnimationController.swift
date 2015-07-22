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
    
    // Mkes the break button disappear
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
}
