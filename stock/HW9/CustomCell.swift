//
//  CustomCell.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/10/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    //@IBOutlet private weak var imgFlag: UIImageView!
    @IBOutlet private weak var lblCountry: UILabel!

    var country: String? {
        didSet {
            //self.imgFlag.image = UIImage(named: country!)
            self.lblCountry.text = country!
        }
    }
}
