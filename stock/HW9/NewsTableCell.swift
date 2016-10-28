//
//  NewsTableCell.swift
//  FirstDemo
//
//  Created by stoic on 4/16/16.
//  Copyright © 2016 Simeng Yu. All rights reserved.
//

import UIKit
import Foundation

class NewsTableCell: UITableViewCell{
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    var authorLabel: UILabel!
    var dateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRectMake(20, 5, 300, 60)
        self.titleLabel.font = UIFont.boldSystemFontOfSize(18)
        self.titleLabel.numberOfLines = 2
        self.addSubview(self.titleLabel)

        self.contentLabel = UILabel()
        self.contentLabel.frame = CGRectMake(20, 75, 300, 80)
        self.contentLabel.font = UIFont.systemFontOfSize(16)
        self.contentLabel.numberOfLines = 4
        self.addSubview(self.contentLabel)
        
        self.authorLabel = UILabel()
        self.authorLabel.frame = CGRectMake(20, 165, 300, 20)
        self.authorLabel.font = UIFont.systemFontOfSize(16)
        self.authorLabel.numberOfLines = 1
        self.authorLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        self.addSubview(self.authorLabel)
        
        self.dateLabel = UILabel()
        self.dateLabel.frame = CGRectMake(20, 195, 300, 20)
        self.dateLabel.font = UIFont.systemFontOfSize(16)
        self.dateLabel.numberOfLines = 1
        self.dateLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        self.addSubview(self.dateLabel)
        
    }
    
    
}