//
//  TableViewCell.swift
//  memeME1
//
//  Created by abdiqani on 08/01/23.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeTitle: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

}
