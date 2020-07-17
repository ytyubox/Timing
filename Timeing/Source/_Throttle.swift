//
//  Throttle.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation

public class Throttler<Input>:EventTimingProtocol {
    public var isEnable: Bool {
        get {throttle.isEnable}
        set {throttle.isEnable = newValue}
    }
    
    public var timeInterval: TimeInterval {
        get {throttle.timeInterval}
        set {throttle.timeInterval = newValue}
    }
    required public init(
    timeInterval: TimeInterval,
    action: ((Input?) -> Void)? = nil) {
        receiver =  TimingReceiver(action: action)
        throttle = _Throttle(
            timeInterval: timeInterval,
            receiver:  receiver)
    }
    
    
    public func receive(_ input: Input) {
        throttle.receive(input)
    }
    
    internal var throttle: _Throttle<Input>
    internal var receiver: TimingReceiver<Input>
}

class _Throttle<Input>:EventTimingProtocol {
    required convenience init(timeInterval: TimeInterval, action: ((Input?) -> Void)?) {
        let receiver =  TimingReceiver<Input>(action: action)
        self.init(timeInterval: timeInterval, receiver: receiver)
    }
    
    var isEnable: Bool = true {
        didSet {
            switch isEnable {
                case true:
                    timer = makeTimer()
                case false:
                    deactivate()
            }
        }
    }
    
    func deactivate() {
        timer?.invalidate()
        timer = nil
    }
    
    init(timeInterval: TimeInterval, receiver: TimingReceiver<Input>? = nil) {
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
        if isEnable {return}
        receiver?.received(value: input)
    }
    
    weak var receiver: TimingReceiver<Input>?
}

