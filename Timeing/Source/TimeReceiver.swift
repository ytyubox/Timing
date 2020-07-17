//
//  TimeReceiver.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation



class TimeReceiver<Output>: DebounceReceiverProtocol {
    internal init(action: ((Output) -> Void)? = nil) {
        self.action = action
    }
    
    func received(value: Output) {
        action?(value)
    }
    var action:((Output) -> Void)?
}
