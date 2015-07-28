//
//  GradientController.swift
//  CALayerPlayground
//
//  Created by Kiran Kunigiri on 7/17/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit

class GradientController {
    
    // The layer of the view to change the gradient of
    var gradientLayer = CAGradientLayer()
    // The UIView that contains the layer
    var layerView = UIView()
    // The main view
    var view = UIView()
    // The arrays with all the information about gradients
    var colorArray: [CGColor] = []
    var gradientArray: [CAGradientLayer] = []
    var currentGradient: CAGradientLayer = CAGradientLayer()
    var currentGradientIndex = 0
    
    // Setup the layer with all information and add the gradient layer to the layerView
    func setupLayer() {
        setupColorArray()
        setupGradientArray()
        
        var hour = Clock.getCurrentHour()
        
        // Set gradient based on the current time
        switch true {
        case hour >= 4 && hour < 9:
            currentGradientIndex = 0
            currentGradient = gradientArray[currentGradientIndex]
            gradientLayer = currentGradient
        case hour >= 9 && hour < 15:
            currentGradientIndex = 1
            currentGradient = gradientArray[currentGradientIndex]
            gradientLayer = currentGradient
        case hour >= 15 && hour < 19:
            currentGradientIndex = 2
            currentGradient = gradientArray[currentGradientIndex]
            gradientLayer = currentGradient
        case hour >= 19 && hour < 22:
            currentGradientIndex = 3
            currentGradient = gradientArray[currentGradientIndex]
            gradientLayer = currentGradient
        case hour >= 22 && hour < 4:
            currentGradientIndex = 4
            currentGradient = gradientArray[currentGradientIndex]
            gradientLayer = currentGradient
        default:
            println("error")
        }
        
        self.layerView.layer.addSublayer(gradientLayer)
    }
    
    // Changes to the next gradient
    func changeNextGradient() {
        // Create the from/to arrays and update the current gradient and its index
        var fromArray = gradientArray[currentGradientIndex].colors
        currentGradientIndex += 1
        var toArray = gradientArray[currentGradientIndex].colors
        currentGradient = gradientArray[currentGradientIndex]

        // Create the animation with CABasicAnimation
        var animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromArray
        animation.toValue = toArray
        animation.duration = 5.0
        
        // Apply the animation
        self.gradientLayer.colors = toArray
        self.gradientLayer.addAnimation(animation, forKey: "colors")
    }
    
    // Changes to a specific gradient for a specific time
    func changeGradient(newGradientIndex: Int, time: Double) {
        // Create the new gradient with the index given
        var newGradient = gradientArray[newGradientIndex]
        // Update the current gradient index
        currentGradientIndex = newGradientIndex
        
        // Create the to/from arrays and update the current gradient
        var fromArray = currentGradient.colors
        var toArray = newGradient.colors
        currentGradient = newGradient
        
        // Create the animation with CABasicAnimation
        var animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromArray
        animation.toValue = toArray
        animation.duration = time
        
        // Apply the animation
        self.gradientLayer.colors = toArray
        self.gradientLayer.addAnimation(animation, forKey: "colors")
    }
    
    // Changes to a custom gradient for a specific time
    func changeCustomGradient(newGradient: CAGradientLayer) {
        
        // Update current gradient
        currentGradient = newGradient
        
        // Apply the animation
        self.gradientLayer = newGradient
    }
    
    // MARK: Color creation/organization functions
    
    func setupColorArray() {
        var color1Morningred = UIColor(red:1.0, green:0.49, blue:0.49, alpha:1.0).CGColor
        var color2MorningOrange = UIColor(red:1.0, green:0.73, blue:0.42, alpha:1.0).CGColor
        var color3MorningBlue = UIColor(red:0.15, green:0.93, blue:0.98, alpha:1.0).CGColor
        var color4MorningWhite = UIColor(white:1.0, alpha:1.0).CGColor
        var color5EveningBlue1 = UIColor(red:0.36, green:0.8, blue:1.0, alpha:1.0).CGColor
        var color6EveningBlue2 = UIColor(red:0.82, green:0.95, blue:1.0, alpha:1.0).CGColor
        var color7NightPurple1 = UIColor(red:0.48, green:0.3, blue:0.79, alpha:1.0).CGColor
        var color8NightPurple2 = UIColor(red:0.34, green:0.3, blue:0.79, alpha:1.0).CGColor
        var color9NightBlack = UIColor(white:0.0, alpha:1.0).CGColor
        var color10NightPurple3 = UIColor(red:0.34, green:0.3, blue:0.79, alpha:1.0).CGColor
        
        colorArray = [color1Morningred, color2MorningOrange, color3MorningBlue, color4MorningWhite, color5EveningBlue1, color6EveningBlue2, color7NightPurple1, color8NightPurple2, color9NightBlack, color10NightPurple3]
    }
    
    func setupGradientArray() {
        var phase1MorningGradient = CAGradientLayer()
        phase1MorningGradient.frame = self.view.bounds
        phase1MorningGradient.colors = [colorArray[0], colorArray[1]]
        phase1MorningGradient.startPoint = CGPoint(x: 0, y: 0)
        phase1MorningGradient.endPoint = CGPoint(x: 0, y: 1)
        var phase2MorningGradient = CAGradientLayer()
        phase2MorningGradient.frame = self.view.bounds
        phase2MorningGradient.colors = [colorArray[2], colorArray[3]]
        phase2MorningGradient.startPoint = CGPoint(x: 0, y: 0)
        phase2MorningGradient.endPoint = CGPoint(x: 0, y: 1)
        var phase3MorningGradient = CAGradientLayer()
        phase3MorningGradient.frame = self.view.bounds
        phase3MorningGradient.colors = [colorArray[4], colorArray[5]]
        phase3MorningGradient.startPoint = CGPoint(x: 0, y: 0)
        phase3MorningGradient.endPoint = CGPoint(x: 0, y: 1)
        var phase4MorningGradient = CAGradientLayer()
        phase4MorningGradient.frame = self.view.bounds
        phase4MorningGradient.colors = [colorArray[6], colorArray[7]]
        phase4MorningGradient.startPoint = CGPoint(x: 0, y: 0)
        phase4MorningGradient.endPoint = CGPoint(x: 0, y: 1)
        var phase5MorningGradient = CAGradientLayer()
        phase5MorningGradient.frame = self.view.bounds
        phase5MorningGradient.colors = [colorArray[8], colorArray[9]]
        phase5MorningGradient.startPoint = CGPoint(x: 0, y: 0)
        phase5MorningGradient.endPoint = CGPoint(x: 0, y: 1)
        
        gradientArray = [phase1MorningGradient, phase2MorningGradient, phase3MorningGradient, phase4MorningGradient, phase5MorningGradient]
    }
}








