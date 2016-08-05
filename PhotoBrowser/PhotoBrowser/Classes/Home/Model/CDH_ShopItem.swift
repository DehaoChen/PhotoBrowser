//
//  CDH_ShopItem.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/4.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

class CDH_ShopItem: NSObject {
    var q_pic_url = ""
    var z_pic_url = ""
    
    init(dict: [String : NSObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {  }
}
