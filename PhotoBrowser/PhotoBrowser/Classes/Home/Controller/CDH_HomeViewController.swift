//
//  CDH_HomeViewController.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/3.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CDH_HomeCollectionViewCell"

class CDH_HomeViewController: UICollectionViewController {

    // Mark:- 定义属性
    var isPresented : Bool = false
    lazy var photoBrowserAnimator : CDH_PhotoBrowserAnimator = CDH_PhotoBrowserAnimator()
    lazy var shops : [CDH_ShopItem] = [CDH_ShopItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        // 注意本项目cell 是通过 storyboard 加载的所以不能通过 class 注册
//        self.collectionView!.registerClass(CDH_HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        // 1. 发送网络请求
        loadData(0)
    }


}

// MARK: - 网络请求的方法
extension CDH_HomeViewController{
    func loadData(offSet : Int) -> Void {
        CDH_NetWorkTools.shareIntance.loadHomeData(offSet) { (resultArray, error) in
            //1.错误校验
            if error != nil{
                return
            }
            
            // 2. 取出可选类型中的数据
            guard let resultArray = resultArray else{
                return
            }
            
            // 3.遍历数组, 将数据中的字典转成模型对象
            for dict in resultArray{
                let shop = CDH_ShopItem(dict: dict)
                self.shops.append(shop)
            }
            
            // 4.刷新表格
            self.collectionView?.reloadData()
        }
    }
}

// MARK : - collectionView 的数据源和代理方法
extension CDH_HomeViewController{
    // MARK: - UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // ?? : 处理可选链,如果可选链中有一个可选类型没有值,那么直接使用 ?? 后面的值
        return shops.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 1.创建 cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CDH_HomeCollectionViewCell
        
        // 2.给 cell 设置数据
        cell.shop = shops[indexPath.row]
        
        
        // 3.判断是哪是否为最后一个 cell 即将显示
        if indexPath.row == shops.count - 1 {
            loadData(shops.count)
        }
        
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    // MARK: - UIcollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 1.创建图片流量器控制器
        let photoBrowser = CDH_PhotoBrowserController()
        
        // 2.设置控制器相关的属性
        photoBrowser.shops = shops
        photoBrowser.indexPath = indexPath
        
        // 设置 photoBrowser 控制器的弹出动画
        // 系统提供的枚举值类型设置弹出动画效果
        // photoBrowser.modalTransitionStyle = .CoverVertical
        // photoBrowser.modalTransitionStyle = .CrossDissolve
        // photoBrowser.modalTransitionStyle = .FlipHorizontal
        // photoBrowser.modalTransitionStyle = .PartialCurl
    /**
    public enum UIModalTransitionStyle : Int {
        
        case CoverVertical  // 直接从底部 modal 出来, 默认的一样
        case FlipHorizontal // 翻转动画
        case CrossDissolve  // 淡入淡出
        @available(iOS 3.2, *)
        case PartialCurl    // 向上翻书的效果
    }
    */
        // 3.设置photoBrowser的弹出动画
        // 需求, 渐变弹出动画化效果, 并且可以看到原来的控制器 View 上的内容
        // 系统默认移除 modal 之前的控制器的 view 才 modal 出新的控制器的 view
        // 所以我们必须在这里设置为自定义转场动画, 保留原来控制器 View 的视图在窗口中不被移除
        // 并给转场动画设置代理, 代理必须遵守协议 UIViewControllerTransitioningDelegate
        photoBrowser.modalPresentationStyle = .Custom
        photoBrowser.transitioningDelegate = photoBrowserAnimator
        // 前面已经定义为属性, 通过懒加载来强引用执行动画的代理

        // 4.弹出控制器
        // 做下面跳转的时候会调用代理方法
        presentViewController(photoBrowser, animated: true, completion: nil)
    }
}





















