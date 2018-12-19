//
//  ViewController.swift
//  animated-tab-menu
//
//  Created by zhenwei12138 on 12/19/2018.
//  Copyright (c) 2018 zhenwei12138. All rights reserved.
//

import UIKit
import animated_tab_menu
class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var menu: AnimatedTabMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.setTitleArray(titles: ["hello world","hello hello world hello world","hello hello world","hello hello world","hello","hello"])
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func changeIndex(_ sender: Any) {
        self.menu.setSelectedSegmentIndex(1, progress: CGFloat(slider.value))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

