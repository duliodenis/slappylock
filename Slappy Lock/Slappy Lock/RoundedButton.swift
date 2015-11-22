//
//  RoundedButton.swift
//  Slappy Lock
//
//  Created by Dulio Denis on 11/22/15.
//  Copyright © 2015 Dulio Denis. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
    }
    
}