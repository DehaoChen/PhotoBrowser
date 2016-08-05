//
//  CDH_PresentedCustomAnimator.swift
//  PhotoBrowser
//
//  Created by chendehao on 16/8/5.
//  Copyright © 2016年 CDH. All rights reserved.
//

import UIKit

// MARK : - 定制协议
protocol CDH_PresentedCustomAnimatorProtocol : class{
    // 设置代理方法
    func getImageView(indexPath : NSIndexPath) -> UIImageView
    func getStartRect(indexPath : NSIndexPath) -> CGRect
    func getEndRect(indexPath : NSIndexPath) -> CGRect
}
protocol CDH_DismissCustomAnimatorProtocol : class{
    // 设置代理方法
    func getImageView() -> UIImageView
    func getIndexPath() -> NSIndexPath
}


class CDH_PresentedCustomAnimator: NSObject {
    var isPresented = false
    var indexPath : NSIndexPath?
    weak var presentedDelegate : CDH_PresentedCustomAnimatorProtocol?
    weak var dismissDelegate : CDH_DismissCustomAnimatorProtocol?
    //    // 写成单例对象
    //    static let shareInstance = CDH_PhotoBrowserAnimator()
    
}



// MARK : - 实现 photoBrowser的转场动画代理方法
extension CDH_PresentedCustomAnimator : UIViewControllerTransitioningDelegate{
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
extension CDH_PresentedCustomAnimator : UIViewControllerAnimatedTransitioning{
    
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
            
            // 0.nil值校验 做两个校验, 就相当于 &&
            guard let indexPath = indexPath, presentedDelegate =  presentedDelegate else{
                return
            }
            
            // 1.获取 modal 弹出的 View
            /**
             // Currently only two keys are defined by the system -
             // UITransitionContextFromViewKey, and UITransitionContextToViewKey
             // viewForKey: may return nil which would indicate that the animator should not
             // manipulate the associated view controller's view.
             */
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            // 2.获取到当前点击的cell的 imageView
            let imageView = presentedDelegate.getImageView(indexPath)
            // 2.1 将 imageView 添加到转场的上下文的 容器 containerView 中一起做动画
            transitionContext.containerView()?.addSubview(imageView)
            // 2.2 设置 imageView 在 containerView 中的 frame
            imageView.frame = presentedDelegate.getStartRect(indexPath)
            
            // 3. 将 containerView 的背景设设置为透明色
            transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
//            transitionContext.containerView()?.alpha = 0.0
            // 3.执行动画
            
            UIView.animateWithDuration(duration, animations: {
                // 设置 imageView 动画最终的 frame
                imageView.frame = presentedDelegate.getEndRect(indexPath)
//                transitionContext.containerView()?.alpha = 1.0
                transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
            }) { (_) in
                
                // 1.动画结束时移除 imageView
                imageView.removeFromSuperview()
                // 2.将弹出来的 View 添加到 containerView 中
                transitionContext.containerView()?.addSubview(presentedView)
                // 3.动画执行结束时要告诉系统动画已经执行完成
                transitionContext.completeTransition(true)
            }
            
        }else{
            
            // 0. nil 值校验
            guard let dismissDelegate = dismissDelegate , presentedDelegate = presentedDelegate else {
                return
            }
            
            // 1.取出 dismiss 掉控制器
            let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            // 直接移除控制器 dismiss
            dismissView?.removeFromSuperview()
            
            // 2.获取到执行动画的 imageView 
            let imageView = dismissDelegate.getImageView()
            transitionContext.containerView()?.addSubview(imageView)
            
            // 3.获取到当前点击的是哪个cell 的索引
            let indexPath = dismissDelegate.getIndexPath()
            
            // 4.根据索引回到主页获取到该索引的 cell 的 frame 
            let endRect = presentedDelegate.getStartRect(indexPath)
            
            // 5.执行动画
            UIView.animateWithDuration(duration, animations: {
                if endRect == CGRectZero {
                    imageView.alpha = 0.0
                }else{
                    imageView.frame = endRect
                }
                
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
            }) { (_) in
                // 执行动画结束移除 imageView
                // imageView.removeFromSuperview()
                // 告诉系统动画已经执行完成
                transitionContext.completeTransition(true)
            }
            
//            // 0.控制校验
//            guard let dismissDelegate = dismissDelegate, presentedDelegate = presentedDelegate else {
//                return
//            }
//            
//            // 1.取出消失的View
//            let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
//            
//            // 2.执行动画
//            // 2.1.获取执行动画的imageView
//            let imageView = dismissDelegate.getImageView()
//            transitionContext.containerView()?.addSubview(imageView)
//            
//            // 2.2.取出indexPath
//            let indexPath = dismissDelegate.getIndexPath()
//            
//            // 2.3.获取结束的位置
//            let endRect = presentedDelegate.getStartRect(indexPath)
//            
//            // 如果出现的 cell 在主页没有显示, 则此时在主页是没有对应的 cell
//            // 也就获取不到的 cell 的 frame , 也就是 CGRectZero
//            // 如果是 CGRectZero 时, 先不隐藏 dismissView
//            // 如果不是 CGRectZero 时, 则对应的 cell 在窗口中显示, 则直接隐藏 dismissView
//            dismissView?.alpha = endRect == CGRectZero ? 1.0 : 0.0
//            // 先通过是否隐藏显示, 然后再在动画结束时移除 dismissView
//            
//            // 2.4.执行动画
//            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
//                if endRect == CGRectZero {
//                    imageView.removeFromSuperview()
//                    dismissView?.alpha = 0.0
//                } else {
//                    imageView.frame = endRect
//                }
//                
//                }, completion: { (_) -> Void in
//                    
//                    dismissView?.removeFromSuperview()
//                    transitionContext.completeTransition(true)
//            })

        }
    }
}
