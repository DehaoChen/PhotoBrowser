//
//  CDH_PhotoBrowserCell.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/4.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit
import SDWebImage

class CDH_PhotoBrowserCell: UICollectionViewCell {
    // MARK : -  懒加载属性
    lazy var imageView : UIImageView = UIImageView()
    
    var shop :  CDH_ShopItem? {
        didSet{
            // 1. nil值校验
            guard let shop = shop else{
                return
            }
            
            // 2. 取出 image 对象 先用小图顶上去
            var image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(shop.q_pic_url)
            if image == nil {
                image = UIImage(named: "empty_picture")
            }
            
            // 3. 根据图片计算 imageView 的 frame
            imageView.frame = caculationImageViewFame(image)
            
            // 4. 设置imageView 的图片
            guard let url = NSURL(string: shop.z_pic_url) else{
                imageView.image = image
                return
            }
            
            // 5.下载大图并设置到 ImageView 中
            imageView.sd_setImageWithURL(url, placeholderImage: image) { (image, _, _, _) in
                // 加载图片完成之后重新计算 imageView 的 frame
                self.imageView.frame = self.caculationImageViewFame(image)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    // required : 如果有实现父类的某一个构造函数,那么必须同时实现使用required修饰的构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(imageView)
    }
}

// MARK : - 根据图片计算imageView的frame
extension CDH_PhotoBrowserCell{
    func caculationImageViewFame(image : UIImage) -> CGRect {
        
        let imageViewW = UIScreen.mainScreen().bounds.width
        let imageViewH = imageViewW * image.size.height / image.size.width
        
        let imageViewY = (UIScreen.mainScreen().bounds.height - imageViewH) * 0.5
        return CGRect(x: 0, y: imageViewY, width: imageViewW, height: imageViewH)
    }
}