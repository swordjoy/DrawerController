//
//  DrawerController.swift
//  DrawerController
//
//  Created by Liu Yang on 2018/10/12.
//  Copyright © 2018 Liu Yang. All rights reserved.
//

import UIKit

// 业务需求暂时这样,后面有其他需求继续完善
class DrawerController: UIViewController {
    fileprivate var rootViewController: UIViewController

    fileprivate var drawerViewController: UIViewController

    init(rootViewController: UIViewController, drawerViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.drawerViewController = drawerViewController
        super.init(nibName: nil, bundle: nil)

        addChild(rootViewController)
        rootViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        rootViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(rootViewController.view)
        rootViewController.didMove(toParent: self)

        addChild(drawerViewController)
        drawerViewController.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        drawerViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(drawerViewController.view)
        drawerViewController.didMove(toParent: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DrawerController {
    func openDrawer() {
        UIView.animate(withDuration: 0.28) {
            self.drawerViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
    }

    func closeDrawer() {
        UIView.animate(withDuration: 0.28) {
            self.drawerViewController.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
    }
}
