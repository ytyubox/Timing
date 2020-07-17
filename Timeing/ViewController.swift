//
//  ViewController.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var debounceLabel: UILabel!
    lazy var debouncer = Debouncer<String>(timeInterval: 0.5)
        {
        self.debounceLabel.text = $0
        self.debounceLabel.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    lazy var throttler = Throttler<String>(timeInterval: 1) { (text) in
        self.throttleLabel.text = text
        self.throttleLabel.sizeToFit()
    }
    @IBAction func didInputDebounce(_ sender: UITextField) {
        debouncer.receive(sender.text!)
    }
    @IBAction func didToggleDebounce(_ sender: UISwitch) {
        debouncer.isEnable = sender.isOn
    }
    
    @IBOutlet weak var throttleLabel: UILabel!
    @IBAction func didInputThrottle(_ sender: UITextField) {
        throttler.receive(sender.text!)
    }
    @IBAction func didToggleThrottle(_ sender: UISwitch) {
        throttler.isEnable = sender.isOn
    }
}
