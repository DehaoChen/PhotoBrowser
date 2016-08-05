//
//  CDH_PhotoBrowserLayout.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/4.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

class CDH_PhotoBrowserLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.设置 layout相关的属性
        itemSize = (collectionView?.bounds.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 设置水平滚动
        scrollDirection = .Horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        // 翻页是以 contentSize 作为单位进行翻页
        collectionView?.pagingEnabled = true
    }

}
