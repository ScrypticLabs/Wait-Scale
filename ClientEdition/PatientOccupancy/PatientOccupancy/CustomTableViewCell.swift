//
//  CustomTableViewCell.swift
//  PatientOccupancy
//
//  Created by Abhi Gupta on 2015-08-14.
//  Copyright (c) 2015 AbhiGupta. All rights reserved.
//

import UIKit

class CustomTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var initialsIcon: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
   
    @IBOutlet weak var waitedTime: UILabel!
    @IBOutlet weak var minute: UILabel!
        
}
