//
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by Sylvester Amponsah on 11/1/18.
//  Copyright © 2018 Sylvester Amponsah. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet var postedImage: UIImageView!
    
    @IBOutlet var comment: UILabel!
    
    @IBOutlet var userInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
