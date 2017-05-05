//
//  ReactiveSelect.swift
//  NiceReactive
//
//  Created by Vojtech Rinik on 5/5/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

protocol SelectOptionValue: Equatable {
    
}

extension SelectOptionValue {
}

public class ReactiveSelect<T: Equatable>: NSObject {
    
    let button: NSPopUpButton
    public var label: ((T) -> (String))?
    let allowsNone: Bool
    public var noneLabel = "-"
    
    internal typealias Option = (value: T?, label: String)
    
    public init(button: NSPopUpButton, allowsNone: Bool = false) {
        self.button = button
        self.allowsNone = allowsNone
    }
    
    public var onChange: ((T?) -> ())? {
        didSet {
            button.target = self
            button.action = #selector(handleButtonAction(sender:))
        }
    }
    
    public var options = [Option]() {
        didSet {
            if allowsNone {
                options.insert((value: nil, label: noneLabel), at: 0)
            }
            
            button.removeAllItems()
            
            for option in options {
                button.addItem(withTitle: option.label)
            }
        }
    }
    
    public var rac_options: BindingTarget<[Option]> {
        return reactive.makeBindingTarget {
            $0.options = $1
            $0.updateSelectFromSelectedValue()
        }
    }
    
    public var rac_values: BindingTarget<[T]> {
        return reactive.makeBindingTarget {
            $0.options = $1.map { (value: $0, label: self.label?($0) ?? "label") }
            $0.updateSelectFromSelectedValue()
        }
    }
    
    public var selectedValue: T? {
        didSet {
            self.updateSelectFromSelectedValue()
        }
    }
    
    func updateSelectFromSelectedValue() {
        let index = self.options.index { $0.value == selectedValue }
        
        if let index = index {
            button.selectItem(at: index)
        } else {
            // Select nil value?
        }
    }
    
    public var rac_selectedValue: BindingTarget<T?> {
        return reactive.makeBindingTarget { base, value in
            base.selectedValue = value
        }
    }
    
    @objc func handleButtonAction(sender: AnyObject?) {
        let index = button.indexOfSelectedItem
        let option = options[index]
        
        self.onChange?(option.value)
    }
}

