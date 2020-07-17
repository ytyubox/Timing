//
//  Debounce.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation
protocol DebounceProtocol {
    associatedtype Input
//    var debounceTime: TimeInterval {get set}
//    var receiver: DebounceReceiver<Input>? {get}
    func receive(_ input:Input)
}
protocol DebounceReceiverProtocol:AnyObject {
    associatedtype Output
    func received(value: Output)
}

class Debouncer<Input>:DebounceProtocol {
    func receive(_ input: Input) {
        debounce.receive(input)
    }
    
    internal init(
        timeInterval: TimeInterval,
        completion: ((Input) -> Void)? = nil) {
        self.receiver = DebounceReceiver(completion: completion)
        self.debounce = Debounce(debounceTime: timeInterval, receiver: receiver)
    }
    
    private var debounce: Debounce<Input>
    private var receiver: DebounceReceiver<Input>
    
}

class Debounce<Input>: DebounceProtocol {
    weak var receiver: DebounceReceiver<Input>?
    
    internal init(
        debounceTime: TimeInterval,
        receiver: DebounceReceiver<Input>
                  ) {
        self.debounceTime = debounceTime
        self.receiver = receiver
    }
    
    var debounceTime: TimeInterval
    var timer:Timer?
    
    func receive(_ input: Input) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: debounceTime,
            repeats: false,
            block: { (timer) in
                self.receiver?.received(value: input)
                self.timer = nil
        })
    }
}

class DebounceReceiver<Output>: DebounceReceiverProtocol {
    internal init(completion: ((Output) -> Void)? = nil) {
        self.completion = completion
    }
    
    func received(value: Output) {
        completion?(value)
    }
    var completion:((Output) -> Void)?
}
