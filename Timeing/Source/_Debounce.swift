//
//  Debounce.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation
public class Debouncer<Input>:EventTimingProtocol {
    public var isEnable: Bool {
        get { debounce.isEnable }
        set { debounce.isEnable = newValue }
    }
    
    public var timeInterval: TimeInterval {
        get {debounce.timeInterval}
        set {debounce.timeInterval = newValue}
    }
    
    public func receive(_ input: Input) {
        debounce.receive(input)
    }
    
    required public init(
        timeInterval: TimeInterval,
        action: ((Input?) -> Void)? = nil) {
        self.receiver = TimingReceiver(action: action)
        self.debounce = _Debounce(timeInterval: timeInterval, receiver: receiver)
    }
    
    internal var debounce: _Debounce<Input>
    internal var receiver: TimingReceiver<Input>
    
}

class _Debounce<Input>: EventTimingProtocol {
    required convenience init(timeInterval: TimeInterval, action: ((Input?) -> Void)?) {
        let receiver =  TimingReceiver<Input>(action: action)
        self.init(timeInterval: timeInterval, receiver: receiver)

    }
    
    
    weak var receiver: TimingReceiver<Input>?
    
    init(
        timeInterval: TimeInterval,
        receiver: TimingReceiver<Input>) {
        self.timeInterval = timeInterval
        self.receiver = receiver
    }
    
    var timeInterval: TimeInterval
    var timer:Timer?
    var isEnable = true {
        didSet {
            if isEnable { return }
            timer?.invalidate()
            receiver?.received(value: value)
        }
    }
    var value: Input?
    func receive(_ input: Input) {
        timer?.invalidate()
        value = input
        guard isEnable else {
            return block(value)
        }
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false,
            block: { (timer) in
                self.block(self.value)
        })
    }
    private func block(_ input: Input?) {
        self.receiver?.received(value: input)
        self.timer = nil
    }
}
