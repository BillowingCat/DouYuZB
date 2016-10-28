//
//  MainViewController.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/28.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

/*
 ios9可以选中直接进行分离
 选中nav和controller 点击 Editor  选 Refactor to storyboard
 
 */

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addChildVc(storyName:String) {
        //1.通过toryboard获取控制器
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        //2.通过childVc作为自控制器
        addChildViewController(childVc)
    }
    

    

}
