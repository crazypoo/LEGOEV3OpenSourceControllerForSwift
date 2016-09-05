//
//  PPortInfoTableViewCell.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class PPortInfoTableViewCell: UITableViewCell {

    var sensorImage:UIImageView?
    var portLabel:UILabel?
    var nameLabel:UILabel?
    var dataLabel:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sensorImage = UIImageView.init(frame: CGRectMake(10, 10, 100, 100))
        portLabel = UILabel.init(frame: CGRectMake(140, 15, 180, 20))
        nameLabel = UILabel.init(frame: CGRectMake(140, 50, 180, 20))
        dataLabel = UILabel.init(frame: CGRectMake(140, 85, 180, 20))

        self.addSubview(sensorImage!)
        self.addSubview(portLabel!)
        self.addSubview(nameLabel!)
        self.addSubview(dataLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
