//
//  CDH_HomeCollectionViewLayout.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/3.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

class CDH_HomeCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        // 注意: 一定要调用父类的方法
        super.prepareLayout()
        
        // 设置为每行只显示3个 cell 左右都有边界 10 
        let CDH_Margin : CGFloat = 10.0
        let rank : CGFloat = 3.0
        let itemWH = (UIScreen.mainScreen().bounds.width - (rank + 1.0) * CDH_Margin) / 3.0 - 0.0001
        // 设置每个 item 的 size
        itemSize = CGSize(width: itemWH, height: itemWH)
        
        // 设置最小的间距
        minimumLineSpacing = CDH_Margin
        minimumInteritemSpacing = CDH_Margin
        
        // 设置 collectionView 的内边距
        collectionView?.contentInset = UIEdgeInsets(top: 64 + CDH_Margin, left: CDH_Margin, bottom: CDH_Margin, right: CDH_Margin)
        
    }

}
