//
//  User.swift
//  SwiftTimer
//
//  Created by Kiran Kunigiri on 7/23/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class User: Object {
    dynamic var number = 0
    dynamic var level = 1
    dynamic var name = ""
}