//
//  UIBarButtonItem-Extention.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/31.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /*
    class func createItem(imageName:String,hightImageName:String,size:CGSize) -> UIBarButtonItem {
        
        let point = CGPoint(x: 0, y: 0)
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: hightImageName), for: .highlighted)
        btn.frame = CGRect(origin: point, size: size)
        return UIBarButtonItem(customView: btn)
    }
   */
    
    /* 
      便利构造函数：1> 以开头
                 2> 在构造函数中必须明确调用一个设计的构造函数(self)
    */
    convenience init(imageName:String,hightImageName:String = "",size:CGSize?) {
        let point = CGPoint(x: 0, y: 0)
        // 1.创建UIButton
        let btn = UIButton()
        // 2.设置btn的图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if hightImageName != "" {
            btn.setImage(UIImage(named: hightImageName), for: .highlighted)
        }
        // 3.设置btn的尺寸
        if let size = size {
            btn.frame = CGRect(origin: point, size: size)
        }else{
            btn.sizeToFit()
        }
        
        //创建btn的item
        self.init(customView: btn)
    }
}
