//
//  ViewController.swift
//  DrawerController
//
//  Created by Liu Yang on 2018/10/12.
//  Copyright © 2018 Liu Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AppDelegate.main.openDrawer()
    }

}

