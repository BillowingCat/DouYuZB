//
//  PageContentView.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/31.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView:PageContentView, progess : CGFloat, sourceIndex : Int, targetIndex : Int)
}



private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    //MARK: - 定义属性
    fileprivate var childVcs:[UIViewController]
    //为了避免PageContentView和HomeViewController互为强引用，互相之间造成循环应用，这里使用弱引用，弱引用必须是可选类型
    fileprivate weak var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScrollerDelete : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    //MARK: -懒加载属性
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        //闭包里面用self也容易造成循环引用,使用[weak self]解决
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.创建UICollectionView
        let collectionFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let collection = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collection
    }()
    
    //MARK: - 自定义构造函数
    init(frame:CGRect, childVcs : [UIViewController] , parentViewController : UIViewController?){
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI界面
extension PageContentView{
    
    fileprivate func setupUI(){
        // 1.将所有的自控制器添加到父控制器中
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        
        // 2.添加UIViewController，用于Cell中存放控制器View
        addSubview(collectionView)
        collectionView.frame = bounds
    
    }
}

//MARK: - 遵守UICollectionViewDataSource协议
extension PageContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        // 2.给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK: - 遵守UICollectionViewDelegate协议
extension PageContentView : UICollectionViewDelegate {
    
    /** 监听开始拖动 */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollerDelete = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    /** 监听collectionView的滚动 */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isForbidScrollerDelete {
            return
        }
        // 1.获取需要的数据
        var progress:CGFloat = 0
        var sourceIndex:Int = 0
        var targetIndex:Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            //左滑  floor:取整
            
            // 1.计算progress
            progress = currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW)
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX/scrollViewW)
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            //右滑
            
            // 1.计算progress
            progress = 1 - (currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW))
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX/scrollViewW)
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.将progress、targetIndex、sourceIndex传递给titleView
        delegate?.pageContentView(contentView: self, progess: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
}

//MARK: - 对外暴露的方法
extension PageContentView {
    
    func setCurrentIndex(currentIndex:Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollerDelete = true
        
        // 2.滚到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
