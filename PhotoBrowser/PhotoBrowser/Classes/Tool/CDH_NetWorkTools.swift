//
//  CDH_NetWorkTools.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/4.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit
import AFNetworking

class CDH_NetWorkTools: AFHTTPSessionManager {
    
    // 将类设计成单利对象
    static let shareIntance : CDH_NetWorkTools = {
        let tool = CDH_NetWorkTools()
        
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tool
    }()
    
    func loadHomeData(offSet : Int , finishedCallback : (resultArray :[[String: NSObject]]?, error : NSError?) -> ()){
        
        // 1. 获取请求的URLString
        let urlString = "http://mobapi.meilishuo.com/2.0/twitter/popular.json?offset=\(offSet)&limit=30&access_token=b92e0c6fd3ca919d3e7547d446d9a8c2"
        
        // 2.发送网络请求
        GET(urlString, parameters: nil, progress: nil, success: { ( dataTask, response) in
            
            // 1.将响应回来的 AnyObject? 转成字典类型
            guard let responseDict = response as? [String : NSObject] else{
                print("没有拿到正确的数据")
                return
            }
            
            // 2.从字典中将数组取出
            let dictArray = responseDict["data"] as? [[String : NSObject]]
            // 3.将数据回调出
            finishedCallback(resultArray: dictArray, error: nil)
            
            }) { (dataTask, error) in
                finishedCallback(resultArray: nil, error: error)
        }
    }
}
