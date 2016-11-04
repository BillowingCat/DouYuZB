//
//  AppDelegate.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/27.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //TabBar下未选中的图标为蓝色
        UITabBar.appearance().tintColor = UIColor.orange
        
        
        return true
    }


}

