//
//  Debounce.swift
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
    func inactive()
}
protocol DebounceReceiverProtocol:AnyObject {
    associatedtype Output
    func received(value: Output)
}

class Debouncer<Input>:EventCutterProtocol {
    func inactive() {
        debounce.inactive()
    }
    
    var timeInterval: TimeInterval {
        get {debounce.timeInterval}
        set {debounce.timeInterval = newValue}
    }
    
    func receive(_ input: Input) {
        debounce.receive(input)
    }
    
    internal init(
        timeInterval: TimeInterval,
        action: ((Input) -> Void)? = nil) {
        self.receiver = TimeReceiver(action: action)
        self.debounce = Debounce(debounceTime: timeInterval, receiver: receiver)
    }
    
    private var debounce: Debounce<Input>
    private var receiver: TimeReceiver<Input>
    
}

class Debounce<Input>: EventCutterProtocol {
    func inactive() {
        timer?.invalidate()
        timer = nil
    }
    
    weak var receiver: TimeReceiver<Input>?
    
    internal init(
        debounceTime: TimeInterval,
        receiver: TimeReceiver<Input>
                  ) {
        self.timeInterval = debounceTime
        self.receiver = receiver
    }
    
    var timeInterval: TimeInterval
    var timer:Timer?
    
    func receive(_ input: Input) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false,
            block: { (timer) in
                self.receiver?.received(value: input)
                self.timer = nil
        })
    }
}

class TimeReceiver<Output>: DebounceReceiverProtocol {
    internal init(action: ((Output) -> Void)? = nil) {
        self.action = action
    }
    
    func received(value: Output) {
        action?(value)
    }
    var action:((Output) -> Void)?
}
