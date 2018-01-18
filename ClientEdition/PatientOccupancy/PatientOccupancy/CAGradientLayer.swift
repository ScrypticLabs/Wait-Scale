//
//  GradientLayer.swift
//  PatientOccupancy
//
//  Created by Abhi Gupta on 2015-08-14.
//  Copyright (c) 2015 AbhiGupta. All rights reserved.
//

import UIKit

extension CAGradientLayer{
    
    func turquoiseColor() -> CAGradientLayer {
        let topCol = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomCol = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientCols: [CGColor] = [topCol.CGColor, bottomCol.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientCols
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
   
}
