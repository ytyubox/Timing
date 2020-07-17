//
//  Protocol.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation
protocol EventCutterProtocol {
    associatedtype Input
    var timeInterval: TimeInterval {get set}
//    var receiver: DebounceReceiver<Input>? {get}
    func receive(_ input:Input)
    var isEnable:Bool {get set}
}
protocol DebounceReceiverProtocol:AnyObject {
    associatedtype Output
    func received(value: Output)
}
