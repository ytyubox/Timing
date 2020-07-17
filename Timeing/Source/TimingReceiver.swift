//
//  TimeReceiver.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation
public class TimingReceiver<Output>: TimingReceiverProtocol {
    public init(action: ((Output?) -> Void)? = nil) {
        self.action = action
    }
    
    public func received(value: Output?) {
        action?(value)
    }
    public var action:((Output?) -> Void)?
}
