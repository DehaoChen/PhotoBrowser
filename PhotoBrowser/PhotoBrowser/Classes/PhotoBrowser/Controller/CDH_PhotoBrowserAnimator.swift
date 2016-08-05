//
//  CDH_PhotoBrowserAnimator.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/5.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

class CDH_PhotoBrowserAnimator: NSObject {
    var isPresented = false
    
//    // 写成单例对象
//    static let shareInstance = CDH_PhotoBrowserAnimator()
    
}
// MARK : - 实现 photoBrowser的转场动画代理方法
extension CDH_PhotoBrowserAnimator : UIViewControllerTransitioningDelegate{
    /**
     告诉 modal 出新控制器的动画有谁来执行方法
     - parameter presented:  被 modal 出来的的控制
     - parameter source:     执行转场动画的控制器
     - returns: 返回执行modal 控制器的动画对象
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        // 设置一个标识, 用来在判断当前是 modal 出新的控制, 还是 dismiss 掉被 modal 出来的控制器
        isPresented = true
        // 方法返回的对象是要遵循协议 UIViewControllerAnimatedTransitioning, 并实现方法
        return self
    }
    
    /**
     告诉消失的动画有谁处理的代理方法
     
     - parameter dismissed: 要被 dismiss 掉的控制器
     - returns: 返回执行 dismiss 掉控制器转场动画的对象
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        // 设置一个标识, 用来在判断当前是 modal 出新的控制, 还是 dismiss 掉被 modal 出来的控制器
        isPresented = false
        // 方法返回的对象是要遵循协议 UIViewControllerAnimatedTransitioning, 并实现方法
        return self
    }
}

// MARK : - 实现photoBrowser的转场的动画
extension CDH_PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{
    
    // This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
    // synchronize with the main animation.
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 1.0
    }
    /**
     决定动画如何实现
     
     - parameter transitionContext: 可以通过转场上下文去获取弹出的 View 和即将消失的 View
     */
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        // 获取转场动画的时间(上面的定义的执行动画的时间)
        let duration = transitionDuration(transitionContext)
        
        if isPresented {
            
            // 1.获取 modal 弹出的 View
            /**
             // Currently only two keys are defined by the system -
             // UITransitionContextFromViewKey, and UITransitionContextToViewKey
             // viewForKey: may return nil which would indicate that the animator should not
             // manipulate the associated view controller's view.
             */
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)
            
            // 2.将弹出来的 View 添加到 containerView 中
            transitionContext.containerView()?.addSubview(presentedView!)
            
            // 3.执行动画
            presentedView?.alpha = 0.0
            UIView.animateWithDuration(duration, animations: {
                presentedView?.alpha = 1.0
            }) { (_) in
                // 动画执行结束时要告诉系统动画已经执行完成
                transitionContext.completeTransition(true)
            }
            
        }else{
            
            // 1.dismiss 掉控制器
            let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            // 2.执行动画
            UIView.animateWithDuration(duration, animations: {
                dismissView?.alpha = 0.0
            }) { (_) in
                
                // 移除控制器
                dismissView?.removeFromSuperview()
                // 告诉系统动画已经执行完成
                transitionContext.completeTransition(true)
            }
        }
    }
}
