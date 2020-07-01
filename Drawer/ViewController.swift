//
//  ViewController.swift
//  Drawer
//
//  Created by Eric JI on 2020/06/30.
//  Copyright © 2020 ericji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let view = UIView(frame: CGRect(x: 0, y: 200, width: 100, height: 100))
        view.backgroundColor = .red
        self.view.addSubview(view)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view1.backgroundColor = .yellow
        self.view.addSubview(view1)
        
    }

    @IBAction func onTapButton(_ sender: Any) {
        let VC = DrawerViewController(originalHeight: 50, finalTopSpaceHeight: 200)
        present(VC, animated: true)
    }
    
}

