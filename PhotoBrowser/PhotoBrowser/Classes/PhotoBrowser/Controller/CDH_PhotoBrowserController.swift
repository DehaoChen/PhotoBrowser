//
//  CDH_PhotoBrowserController.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/4.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

class CDH_PhotoBrowserController: UIViewController {

    // MARK: - 定义数据属性
    var shops : [CDH_ShopItem]?
    var indexPath : NSIndexPath?
    
    // 重用标识
    let photoBrowserCellID = "photoBrowserCell"
    
    
    
    // MARK: - 定义UI属性
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: CDH_PhotoBrowserLayout())
    lazy var closeButton : UIButton = UIButton()
    lazy var saveButton : UIButton = UIButton()
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.frame.width += 15 // 上面的写法是错的
        view.frame.size.width += 15
        
        
        // 布局子控件UIView
        setUpUI()
        
        // 设置滚动对应的位置
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .Left, animated: false)
    }
}

// MARK: - 布局子控件
extension CDH_PhotoBrowserController {
    // 1.添加子控件
    func setUpUI(){
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 准备子控件
        prepareButton()
        
        // 准备 colectionView
        prepareColectionView()
    }
    
    func prepareButton() -> Void {
        
        // 1.配置按钮的frame
        setUpButtonFrame()
        
        setUpButton(closeButton, title: "关 闭", action: "closeButtonClick")
        setUpButton(saveButton, title: "保 存", action: "saveButtonClick")
        
    }
    /** 配置按钮的 frame */
    func setUpButtonFrame()  {
        // 1.配置按钮的位置尺寸
        let CDH_Margin : CGFloat = 20
        let buttonW : CGFloat = 90
        let buttonH : CGFloat = 32
        
        let y : CGFloat = UIScreen.mainScreen().bounds.height - CDH_Margin - buttonH
        
        // 设置关闭按钮的位置尺寸
        closeButton.frame = CGRect(x: CDH_Margin, y: y, width: buttonW, height: buttonH)
        
        let x = UIScreen.mainScreen().bounds.width - buttonW - CDH_Margin
        saveButton.frame = CGRect(x: x, y: y, width: buttonW, height: buttonH)
    }
    
    /**
     配置那妞的基本设置
     
     - parameter button: 按钮
     - parameter title:  按钮标题
     - parameter action: 监听点击事件调用的方法
     */
    func setUpButton(button : UIButton, title : String, action : String) -> Void {
        button.setTitle(title, forState: .Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        //监听按钮点击事件
        button.addTarget(self, action: Selector(action), forControlEvents: .TouchUpInside)
    }
    
    /** 配置 collectionView */
    func prepareColectionView()  {
        
        // 设置位置尺寸
        collectionView.frame = view.bounds
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册自定义 cell
        collectionView.registerClass(CDH_PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellID)
    }
}

// MARK : - CollectionView DataSource & Delegate
extension CDH_PhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // ?? : 处理可选链,如果可选链中有一个可选类型没有值,那么直接使用 ?? 后面的值
        return shops?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 创建 cell 强制转为自定义的 cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellID, forIndexPath: indexPath) as! CDH_PhotoBrowserCell
        
        // 2.设置 cell 的内容
        cell.shop = shops![indexPath.row]
//        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.redColor() : UIColor.blueColor()
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 点击 cell 的时候也退出大图全屏模式
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK : - 监听按钮点击事件调用的方法
extension CDH_PhotoBrowserController{
    @objc private func closeButtonClick()  {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 保存图片
    @objc private func saveButtonClick() {
        // 1.取出当前正在显示的图片
        let cell = collectionView.visibleCells().first as! CDH_PhotoBrowserCell
        
        guard let image = cell.imageView.image else{
            return
        }
        // 2.保存图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}

























