//
//  MyTableViewCell.swift
//  FirstDemo
//
//  Created by stoic on 4/13/16.
//  Copyright © 2016 Simeng Yu. All rights reserved.
//
import UIKit
import Foundation

class MyTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var contentLabel: UILabel!
    
    var arrowImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.nameLabel = UILabel()
        self.nameLabel.frame = CGRectMake(10, 5, 120, 60)
        self.nameLabel.font = UIFont.boldSystemFontOfSize(16)
        self.addSubview(self.nameLabel)
        
        self.contentLabel = UILabel()
        self.contentLabel.frame = CGRectMake(160, 5, 140, 60)
        self.contentLabel.font = UIFont.systemFontOfSize(14)
        self.addSubview(self.contentLabel)
        
        self.arrowImage = UIImageView()
        self.arrowImage.frame = CGRectMake(300, 15, 30, 30)
        self.addSubview(self.arrowImage)
        self.arrowImage.hidden = true
    }
}