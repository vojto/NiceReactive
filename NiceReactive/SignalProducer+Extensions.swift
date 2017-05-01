//
//  SignalProducer+Extensions.swift
//  NiceReactive
//
//  Created by Vojtech Rinik on 4/26/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation
import ReactiveSwift

public func convert<T>(_ value: AnyObject?) -> T? {
    return value as? T
}

public func asURL(_ value: Any?) -> URL? {
    return value as? URL
}

public func asInt(_ value: Any?) -> Int? {
    return value as? Int
}

public func asRequiredInt(_ value: Any?) -> Int {
    return value as? Int ?? 0
}

public func asBool(_ value: Any?) -> Bool? {
    return value as? Bool
}

public func asRequiredBool(_ value: Any?) -> Bool {
    return value as? Bool ?? false
}

public func asString(_ value: Any?) -> String? {
    return value as? String
}

public func asDate(_ value: Any?) -> Date? {
    return value as? Date
}

public func asNSSet(_ value: Any?) -> NSSet? {
    return value as? NSSet
}

public extension SignalProducer where Value: OptionalProtocol {
    func pick<T: OptionalProtocol>(_ picking: @escaping ((Value.Wrapped) -> (SignalProducer<T, Error>))) -> SignalProducer<T.Wrapped?, Error> {
        return self.flatMap(.latest) { value -> SignalProducer<T.Wrapped?, Error> in
            if let value = value.optional {
                return picking(value).map { $0.optional }
            } else {
                return SignalProducer<T.Wrapped?, Error>(value: nil)
            }
        }
    }
    
    
    func pick<T>(_ picking: @escaping ((Value.Wrapped) -> (SignalProducer<T, Error>))) -> SignalProducer<T?, Error> {
        return self.flatMap(.latest) { value -> SignalProducer<T?, Error> in
            if let value = value.optional {
                return picking(value).map { $0 as T? }
            } else {
                return SignalProducer<T?, Error>(value: nil)
            }
        }
    }
}
