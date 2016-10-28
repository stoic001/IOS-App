//
//  LikeTableCell.swift
//  FirstDemo
//
//  Created by stoic on 4/16/16.
//  Copyright © 2016 Simeng Yu. All rights reserved.
//

import UIKit
import Foundation

class LikeTableCell: UITableViewCell {
    var symbolLabel: UILabel!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var changeLabel: UILabel!
    var capLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        self.symbolLabel = UILabel()
        self.symbolLabel.frame = CGRectMake(10, 5, 80, 30)
        self.symbolLabel.font = UIFont.boldSystemFontOfSize(18)
        self.addSubview(self.symbolLabel)
        
        self.priceLabel = UILabel()
        self.priceLabel.frame = CGRectMake(115, 5, 100, 30)
        self.priceLabel.font = UIFont.boldSystemFontOfSize(18)
        self.addSubview(self.priceLabel)
        
        self.changeLabel = UILabel()
        self.changeLabel.frame = CGRectMake(215, 5, 135, 30)
        self.changeLabel.font = UIFont.boldSystemFontOfSize(18)
        self.addSubview(self.changeLabel)
        
        self.nameLabel = UILabel()
        self.nameLabel.frame = CGRectMake(10, 40, 145, 30)
        self.nameLabel.font = UIFont.systemFontOfSize(16)
        self.addSubview(self.nameLabel)

        self.capLabel = UILabel()
        self.capLabel.frame = CGRectMake(160, 40, 200, 30)
        self.capLabel.font = UIFont.systemFontOfSize(16)
        self.addSubview(self.capLabel)


    }

    
}