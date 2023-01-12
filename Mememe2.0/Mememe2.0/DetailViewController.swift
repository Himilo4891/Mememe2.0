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
    
//    @IBOutlet weak var memeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        memeLabel.text = self.meme.name
        memeImage.image = UIImage(named: meme.imageName)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
