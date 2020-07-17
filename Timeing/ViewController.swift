//
//  ViewController.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var debouncer = Debounce<String>(timeInterval: 0.5)
    {
        self.debounceLabel.text = $0
        self.debounceLabel.sizeToFit()
    }
    @IBOutlet weak var debounceLabel: UILabel!
    @IBAction func didInputDebounce(_ sender: UITextField) {
        debouncer.receive(sender.text!)
    }
    @IBAction func didToggleDebounce(_ sender: UISwitch) {
        debouncer.isEnable = sender.isOn
    }
    @IBOutlet weak var debounceStepperLabel: UILabel!
    @IBAction func didChangeDebounceStepper(_ sender: UIStepper) {
        debounceStepperLabel.text = sender.value.description
        debouncer.timeInterval = sender.value
    }
    // MARK: - Throttle
    lazy var throttler = Throttle<String>(timeInterval: 1) { (text) in
        self.throttleLabel.text = text
        self.throttleLabel.sizeToFit()
    }
    @IBOutlet weak var throttleLabel: UILabel!
    @IBAction func didInputThrottle(_ sender: UITextField) {
        throttler.receive(sender.text!)
    }
    @IBAction func didToggleThrottle(_ sender: UISwitch) {
        throttler.isEnable = sender.isOn
    }
    @IBOutlet weak var throttleStepperLabel: UILabel!
    @IBAction func didChangeThrottleStepper(_ sender: UIStepper) {
        throttleStepperLabel.text = sender.value.description
        throttler.timeInterval = sender.value
    }
}
