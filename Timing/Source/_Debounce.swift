//
//  Debounce.swift
//  Timeing
//
//  Created by 游宗諭 on 2020/7/17.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation

public class Debounce<Input>:EventTimingProtocol {
    required public init(
        timeInterval: TimeInterval,
        isEnable: Bool = true,
        action: ((Input?) -> Void)? = nil) {
        self.receiver = TimingReceiver(action: action)
        self.debounce = _Debounce(
            timeInterval: timeInterval,
            receiver: receiver,
            isEnable: isEnable)
    }
    
    internal var debounce: _Debounce<Input>
    internal var receiver: TimingReceiver<Input>
    
    public var isEnable: Bool {
        get { debounce.isEnable }
        set { debounce.isEnable = newValue }
    }
    
    public var timeInterval: TimeInterval {
        get {debounce.timeInterval}
        set {debounce.timeInterval = newValue}
    }
    
    public func receive(_ input: Input?) {
        debounce.receive(input)
    }
}

class _Debounce<Input>: EventTimingProtocol {
    init(timeInterval: TimeInterval,
         receiver: TimingReceiver<Input>,
         isEnable:Bool) {
        self.timeInterval = timeInterval
        self.receiver = receiver
        self.isEnable = isEnable
    }
    required convenience init(
        timeInterval: TimeInterval,
        isEnable: Bool,
        action: ((Input?) -> Void)?
    ) {
        let receiver =  TimingReceiver<Input>(action: action)
        self.init(timeInterval: timeInterval, receiver: receiver,isEnable: isEnable)
        
    }
    
    var isEnable = true { didSet { didSetIsEnable() } }
    var timeInterval: TimeInterval
    var timer:Timer?
    var value: Input?
    weak var receiver: TimingReceiver<Input>?
    
    func receive(_ input: Input?) {
        timer?.invalidate()
        value = input
        guard isEnable else {
            return block()
        }
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false) {
                (timer) in
                self.block()
        }
    }
    private func didSetIsEnable() {
        if isEnable { return }
        timer?.invalidate()
        receiver?.received(value: value)
    }
    private func block() {
        self.receiver?.received(value: value)
        self.timer = nil
    }
}
