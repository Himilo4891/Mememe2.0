//
//  SentMemeCollectionViewCell.swift
//  memeME1
//
//  Created by abdiqani on 08/01/23.

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 8
    }
}
