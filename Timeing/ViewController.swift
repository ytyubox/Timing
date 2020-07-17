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

    @IBAction func didInputDebounce(_ sender: UITextField) {
        debouncer.receive(sender.text!)
    }
    
}
