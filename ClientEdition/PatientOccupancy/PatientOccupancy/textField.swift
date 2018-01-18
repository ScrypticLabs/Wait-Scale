//
//  textField.swift
//  PatientOccupancy
//
//  Created by Abhi Gupta on 2015-08-16.
//  Copyright (c) 2015 AbhiGupta. All rights reserved.
//

import Foundation

private var maxLengthDictionary = [UITextField:Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = maxLengthDictionary[self] {
                return length
            } else {
                return Int.max
            }
        }
        set {
            maxLengthDictionary[self] = newValue
            addTarget(self, action: "checkMaxLength:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    func checkMaxLength(sender: UITextField) {
        let newText = sender.text
        if count(newText) > maxLength {
            let cursorPosition = selectedTextRange
            text = (newText as NSString).substringWithRange(NSRange(location: 0, length: maxLength))
            selectedTextRange = cursorPosition
        }
    }
}