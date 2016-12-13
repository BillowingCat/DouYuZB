//
//  HomeViewController.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/31.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

import UIKit

private let kTitltViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
    //MARK: - 懒加载属性
    
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitltViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        // 1.确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitltViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitltViewH, width: kScreenW, height: contentH)
        // 2.确定所有的自控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置UI界面
        setupUI()
        
    }

}

//MARK: - 设置UI界面
extension HomeViewController {
    
    fileprivate func setupUI() {
        // 0.不需要UIScrollerView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.添加TitleView
        view.addSubview(pageTitleView)
        
        // 3.添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
       
    }
    
    private func setupNavigationBar(){
        // 1.设置左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", size: nil)
        
        // 2.设置右侧Item
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", hightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", hightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", hightImageName: "Image_scan_click", size: size)

        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }
}

//MARK: - 遵守协议

extension HomeViewController : PageTitleViewDelegate {
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//MARK: - 遵守协议

extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progess: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWith(progress: progess, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}




