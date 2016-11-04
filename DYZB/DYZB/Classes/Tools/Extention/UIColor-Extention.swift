//
//  UIColor-Extention.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/31.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
