//
//  PageTitleView.swift
//  DYZB
//
//  Created by 訾玉洁 on 2016/10/31.
//  Copyright © 2016年 鼎商动力. All rights reserved.
//

/*
 一、封装PageTitleView
    1.自定义View,并且自定义构造函数
    2.添加子控件：UIScrollerView
    3.设置顶部的线段
 二、封装PageContentView
    1.自定义View,并且自定义构造函数
    2.添加子控件：1>UICollectionView 2>给UICollectionView设置内容
 三、处理PageTitleView&PageContentView的逻辑
    1.PageTitleView发生点击事件
        将PageTitleView中逻辑进行处理
        告知PageContentView滚动到正确的控制器
    2.PageContentView的滚动
 
 
 
 */



import UIKit

//MARK: - 定义协议
//class 表示这个协议只有类能遵守
protocol PageTitleViewDelegate : class {
    
    /** pageTitle点击 */
    func pageTitleView(titleView : PageTitleView, selectedIndex index : Int)
}

//MARK: - 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

//MARK: - 定义类
class PageTitleView: UIView {
    //MARK: - 定义属性
    fileprivate var currentIndex : Int = 0
    fileprivate var titles:[String]
    weak var delegate : PageTitleViewDelegate?
    
    //MARK: - 懒加载属性
    fileprivate lazy var titleLabels:[UILabel] = [UILabel]()
    
    fileprivate lazy var scrollerView : UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.scrollsToTop = false
        scrollerView.bounces = false
        return scrollerView
    }()
    
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()

    //MARK: - 自定义构造函数
    init(frame:CGRect, titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 设置UI界面
extension PageTitleView {
    
    /** 设置UI */
    fileprivate func setupUI(){
        // 1.添加UIScrollerView
        addSubview(scrollerView)
        scrollerView.frame = bounds
        
        // 2.添加title对应的Label
        setupTitleLabels()
        
        // 3.设置底线和滚动滑块
        setupBottomLineAndScrollLine()
    }
    
    /** 添加title对应的Label */
    private func setupTitleLabels() {
        for (index,title) in titles.enumerated() {
            // 0.确定label的一些frame值
            let labelW : CGFloat = frame.width / CGFloat(titles.count)
            let labelH : CGFloat = frame.height - kScrollLineH
            let labelY : CGFloat = 0
            
            // 1.创建label
            let label = UILabel()
            
            // 2.设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            // 3.设置Label的frame
            
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4.将label添加到scrollerView中
            scrollerView.addSubview(label)
            titleLabels.append(label)
            
            // 5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    /** 设置底线和滚动滑块 */
    private func setupBottomLineAndScrollLine() {
        // 1.添加低底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH:CGFloat = 0.5
        
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2.添加scrollerLine
        // 2.1获取第一个label
        guard let firstLabel = titleLabels.first else {
            return
        }
        // 2.2设置scrollLine的属性
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.size.width, height: kScrollLineH)
        scrollerView.addSubview(scrollLine)
    }
}

//MARK: -  监听title点击
extension PageTitleView {
    // 监听事件@objc开头
    // 监听title点击
    @objc fileprivate func titleLabelClick(tapGes : UITapGestureRecognizer) {
        // 1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.保存最新label的下标值
        currentIndex = currentLabel.tag
        
        // 5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}


//MARK: - 对外暴露方法
extension PageTitleView {
    func setTitleWith(progress:CGFloat, sourceIndex:Int, targetIndex:Int)  {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色的渐变
        // 3.1取出变化的范围
        let  colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 3.2变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0*progress, g: kSelectColor.1 - colorDelta.1*progress, b: kSelectColor.2 - colorDelta.2*progress)
        // 3.3变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0*progress, g: kNormalColor.1 + colorDelta.1*progress, b: kNormalColor.2 + colorDelta.2*progress)
        // 4.记录最新index
        currentIndex = targetIndex
        
    }
}
