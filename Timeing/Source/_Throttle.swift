//
//  Throttle.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation

public class Throttle<Input>:EventTimingProtocol {
    required public init(
        timeInterval: TimeInterval,
        isEnable: Bool = false,
        action: ((Input?) -> Void)? = nil) {
        receiver =  TimingReceiver(action: action)
        throttle = _Throttle(
            timeInterval: timeInterval,
            receiver:  receiver,
            isEnable: isEnable)
    }
    
    internal var throttle: _Throttle<Input>
    internal var receiver: TimingReceiver<Input>
    
    public var isEnable: Bool {
        get {throttle.isEnable}
        set {throttle.isEnable = newValue}
    }
    
    public var timeInterval: TimeInterval {
        get {throttle.timeInterval}
        set {throttle.timeInterval = newValue}
    }
    
    public func receive(_ input: Input?) {
        throttle.receive(input)
    }
}

class _Throttle<Input>:EventTimingProtocol {
    init(timeInterval: TimeInterval,
         receiver: TimingReceiver<Input>? = nil,
         isEnable:Bool) {
        self.timeInterval = timeInterval
        self.receiver = receiver
        self.isEnable = isEnable
        makeTimer()
    }
    required convenience init(
        timeInterval: TimeInterval,
        isEnable:Bool,
        action: ((Input?) -> Void)?) {
        let receiver =  TimingReceiver<Input>(action: action)
        self.init(timeInterval: timeInterval,
                  receiver: receiver,
                  isEnable: isEnable)
    }
    
    var isEnable: Bool { didSet { didSetIsEnable() } }
    var timer:Timer? {didSet {oldValue?.invalidate()}}
    var timeInterval: TimeInterval
    var value: Input?
    weak var receiver: TimingReceiver<Input>?
    
    func receive(_ input: Input?) {
        self.value = input
        if isEnable {return}
        receiver?.received(value: input)
    }
    
    private func didSetIsEnable() {
        makeTimer()
    }
    
    private func deactivate() {
        timer?.invalidate()
        timer = nil
    }
    
    private func makeTimer() {
       timer = (isEnable)
        ? Timer.scheduledTimer(withTimeInterval: timeInterval,
                               repeats: true,
                               block: timerDidHit)
        : nil
    }
    
    private func timerDidHit(timer: Timer) {
        self.receiver?.received(value: self.value)
    }
}

