//
//  Extensions.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/16/15.
//  Copyright © 2015 Dulio Denis. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
}