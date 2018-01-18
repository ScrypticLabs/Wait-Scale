//
//  String.swift
//  PatientOccupancy
//
//  Created by Abhi Gupta on 2015-08-14.
//  Copyright (c) 2015 AbhiGupta. All rights reserved.
//

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    
    var capitalizeIt:String {
        var result = Array(self)
        if !isEmpty { result[0] = Character(String(result.first!).uppercaseString) }
        return String(result)
    }
}