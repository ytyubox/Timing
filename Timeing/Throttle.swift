//
//  Throttle.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation

class Throttler<Input>:EventCutterProtocol {
    func inactive() {
        throttle.inactive()
    }
    
    var timeInterval: TimeInterval {
        get {throttle.timeInterval}
        set {throttle.timeInterval = newValue}
    }
    internal init(
    timeInterval: TimeInterval,
    action: ((Input) -> Void)? = nil) {
        receiver =  TimeReceiver(action: action)
        throttle = Throttle(
            timeInterval: timeInterval,
            receiver:  receiver)
    }
    
    
    func receive(_ input: Input) {
        throttle.receive(input)
    }
    
    var throttle: Throttle<Input>
    var receiver: TimeReceiver<Input>
}

class Throttle<Input>:EventCutterProtocol {
    func inactive() {
        timer?.invalidate()
    }
    
    internal init(timeInterval: TimeInterval, receiver: TimeReceiver<Input>? = nil) {
        self.timeInterval = timeInterval
        self.receiver = receiver
        timer = makeTimer()
    }
    func makeTimer() -> Timer {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer) in
            guard let value = self.value else {return}
            self.receiver?.received(value: value)
        }
    }
    var timer:Timer?
    var timeInterval: TimeInterval
    var value: Input?
    func receive(_ input: Input) {
        self.value = input
    }
    
    weak var receiver: TimeReceiver<Input>?
}

