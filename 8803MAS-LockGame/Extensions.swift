//
//  Extensions.swift
//  8803MAS-LockGame
//
//  Created by yxue on 8/31/19.
//  Copyright © 2019 yxue. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}
