//
//  Debounce.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation

class Debouncer<Input>:EventCutterProtocol {
    var isEnable: Bool {
        get {
            debounce.isEnable
        }
        set {
            debounce.isEnable = newValue
        }
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
    
    func deactivate() {
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
    var isEnable = true
    
    func receive(_ input: Input) {
        timer?.invalidate()
        guard isEnable else {
            return block(input)
        }
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false,
            block: { (timer) in
                self.block(input)
        })
    }
    private func block(_ input: Input) {
        self.receiver?.received(value: input)
        self.timer = nil
    }
}
