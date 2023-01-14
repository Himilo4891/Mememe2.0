//
//  DetailViewController.swift
//  memeME1
//
//  Created by abdiqani on 08/01/23.
//
import Foundation
import UIKit
class DetailViewController: UIViewController {
    
    var meme: Meme!
    
    
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImage.image = meme.memedImage
    }
    
}
