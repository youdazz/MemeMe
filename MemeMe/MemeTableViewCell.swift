//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Youda Zhou on 9/11/23.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
