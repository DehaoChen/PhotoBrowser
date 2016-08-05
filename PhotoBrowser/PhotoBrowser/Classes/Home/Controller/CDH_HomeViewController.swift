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
        
        // 设置 photoBrowser 的弹出动画 
        // 系统提供的枚举值类型设置弹出动画效果
//        photoBrowser.modalTransitionStyle = .CoverVertical
        photoBrowser.modalTransitionStyle = .CrossDissolve
        
        // 3.弹出控制器
        presentViewController(photoBrowser, animated: true, completion: nil)
    }
}




















