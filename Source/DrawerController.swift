//
//  DrawerController.swift
//  DrawerController
//
//  Created by Liu Yang on 2018/10/12.
//  Copyright © 2018 Liu Yang. All rights reserved.
//

import UIKit

// 业务需求暂时这样,后面有其他需求继续完善
extension Notification.Name {
    public struct Drawer {
        public static let openDrawer = Notification.Name(rawValue: "cn.tsingho.qingyun.notification.name.Drawer.OpenDrawer")
        public static let closeDrawer = Notification.Name(rawValue: "cn.tsingho.qingyun.notification.name.Drawer.CloseDrawer")
    }
}

extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

// 业务需求暂时这样,后面有其他需求继续完善
class DrawerController: UIViewController {
    var rootViewController: UIViewController
    var isMenu = false
    fileprivate var drawerViewController: UIViewController
    fileprivate let animator = DrawerAnimator()
    fileprivate var isAnimated = false
    
    init(rootViewController: UIViewController, drawerViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.drawerViewController = drawerViewController
        super.init(nibName: nil, bundle: nil)
        
        addChild(rootViewController)
        rootViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        rootViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(rootViewController.view)
        rootViewController.didMove(toParent: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openDrawer), name: Notification.Name.Drawer.openDrawer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeDrawer), name: Notification.Name.Drawer.closeDrawer, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DrawerController {
    @objc func openDrawer() {
        if isAnimated { return }
        
        isAnimated = true
        animator.isOpen = true
        
        rootViewController.willMove(toParent: nil)
        
        drawerViewController.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        drawerViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        drawerViewController.view.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(drawerViewController.view)
        addChild(drawerViewController)
        
        let context = DrawerContext(fromViewController: rootViewController, toViewController: drawerViewController)
        context.completionBlock = { isFinish in
            self.rootViewController.view.removeFromSuperview()
            self.rootViewController.removeFromParent()
            self.drawerViewController.didMove(toParent: self)
            self.isAnimated = false
            self.isMenu = true
        }
        
        animator.animateTransition(using: context)
    }
    
    @objc func closeDrawer() {
        if isAnimated { return }
        
        isAnimated = true
        animator.isOpen = false
        
        drawerViewController.willMove(toParent: nil)
        
        rootViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        rootViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(rootViewController.view)
        addChild(self.rootViewController)
        
        let context = DrawerContext(fromViewController: drawerViewController, toViewController: rootViewController)
        context.completionBlock = { isFinish in
            self.drawerViewController.view.removeFromSuperview()
            self.drawerViewController.removeFromParent()
            self.rootViewController.didMove(toParent: self)
            self.isAnimated = false
            self.isMenu = false
        }
        
        animator.animateTransition(using: context)
    }
}

class DrawerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isOpen = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)  else {
            return
        }
        let fromView = fromViewController.view!
        let toView = toViewController.view!
        
        if isOpen {
            fromView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            toView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height)
            containerView.addSubview(toView)
        } else {
            toView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            fromView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.isOpen {
                toView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            } else {
                fromView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height)
            }
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class DrawerContext: NSObject, UIViewControllerContextTransitioning {
    init(fromViewController: UIViewController, toViewController: UIViewController) {
        self.presentationStyle = .custom
        self.containerView = fromViewController.view.superview!
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        super.init()
    }
    
    // MARK: custom
    var completionBlock: ((Bool) -> Void)?
    unowned var fromViewController: UIViewController
    unowned var toViewController: UIViewController
    
    // MARK: UIViewControllerContextTransitioning
    unowned var containerView: UIView
    var presentationStyle: UIModalPresentationStyle
    
    var isAnimated: Bool {
        return fromViewController.transitionCoordinator == nil ? false : true
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        switch key {
        case UITransitionContextViewControllerKey.from:
            return fromViewController
        case UITransitionContextViewControllerKey.to:
            return toViewController
        default:
            return nil
        }
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        switch key {
        case UITransitionContextViewKey.from:
            return fromViewController.view
        case UITransitionContextViewKey.to:
            return toViewController.view
        default:
            return nil
        }
    }
    
    func completeTransition(_ didComplete: Bool) {
        completionBlock?(didComplete)
    }
    
    // 没有使用
    var targetTransform: CGAffineTransform {
        return CGAffineTransform.identity
    }
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        return CGRect.zero
    }
    
    func finalFrame(for vc: UIViewController) -> CGRect {
        return CGRect.zero
    }
    
    // 非交互所以没使用
    var isInteractive: Bool {
        return false
    }
    
    var transitionWasCancelled: Bool {
        return false
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) { }
    
    func finishInteractiveTransition() { }
    
    func cancelInteractiveTransition() { }
    
    func pauseInteractiveTransition() { }
}
