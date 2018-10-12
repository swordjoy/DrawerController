//
//  PoPViewController.swift
//  DrawerController
//
//  Created by Liu Yang on 2018/10/12.
//  Copyright © 2018 Liu Yang. All rights reserved.
//

import UIKit

class PoPViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blue
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AppDelegate.main.closeDrawer()
    }
    
}
