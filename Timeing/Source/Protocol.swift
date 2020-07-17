//
//  Protocol.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation
public protocol EventTimingProtocol {
    associatedtype Input
    init(timeInterval: TimeInterval,
         action: ((Input?) -> Void)?)
    func receive(_ input:Input)
    var timeInterval: TimeInterval {get set}
    var isEnable:Bool {get set}
}
public protocol TimingReceiverProtocol:AnyObject {
    associatedtype Output
    func received(value: Output?)
}
