//
//  CDH_HomeCollectionViewCell.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/4.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit
import SDWebImage


class CDH_HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var shop : CDH_ShopItem?  {
        didSet {
            // 0.校验模型是否有值
            guard let shop = shop else {
                return
            }
            
            // 1.取出图片的URLString
            guard let url = NSURL(string: shop.q_pic_url) else {
                return
            }
            
            // 2.设置图片
            let placeHolderImage = UIImage(named: "empty_picture")
            imageView.sd_setImageWithURL(url, placeholderImage: placeHolderImage)
        }
    }

//    var shop : CDH_ShopItem? {
//        didSet {
//            
//            // 1.校验模型属性是否有值
//            guard let shop = shop else{
//                return
//            }
//            
//            // 2. 取出图片的 urlString
//            guard let url = NSURL(string: shop.q_pic_url) else{
//                return
//            }
//            
//            // 3. 设置图片
//            let placeHolderImage = UIImage(named: "empty_picture")
//            imageView.sd_setImageWithURL(url, placeholderImage: placeHolderImage)
//            
//         }
//    }
    
}
