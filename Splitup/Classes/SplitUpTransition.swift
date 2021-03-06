//
//  SplitUpTransition.swift
//  Splitup
//
//  Created by Alexander Bozhko on 19/02/2019.
//

import UIKit

public class SplitUpTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let vc = presented as? SplitUpViewController else { return nil }
        if vc.rearViewController == nil {
            return NonRearPresentAnimation()
        }
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let vc = dismissed as? SplitUpViewController else { return nil }
        if vc.rearViewController == nil {
            return NonRearDismissAnimation()
        }
        return nil
    }

}

internal extension SplitUpTransition {
    
    class NonRearPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.35
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let toVC = transitionContext.viewController(forKey: .to) as? SplitUpViewController else {
                transitionContext.completeTransition(false)
                return
            }
            let container = transitionContext.containerView
            toVC.view.frame = container.bounds
            container.addSubview(toVC.view)
            
            let fromVC = transitionContext.viewController(forKey: .from)
            fromVC?.beginAppearanceTransition(false, animated: true)
            
            toVC.splitUpView.setState(.down, animated: false)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toVC.splitUpView.setState(.up, animated: false)
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if transitionContext.transitionWasCancelled {
                    fromVC?.beginAppearanceTransition(true, animated: true)
                }
                fromVC?.endAppearanceTransition()
            }
        }

    }
    
    class NonRearDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.35
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromVC = transitionContext.viewController(forKey: .from) as? SplitUpViewController else {
                transitionContext.completeTransition(false)
                return
            }
            let container = transitionContext.containerView
            
            let toVC = transitionContext.viewController(forKey: .to)
            toVC?.beginAppearanceTransition(true, animated: true)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromVC.view.frame.origin.y = container.bounds.maxY
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if transitionContext.transitionWasCancelled {
                    toVC?.beginAppearanceTransition(false, animated: true)
                } else {
                    fromVC.view.removeFromSuperview()
                }
                toVC?.endAppearanceTransition()
            }
        }
        
    }
    
}
