//
//  DetailViewController.swift
//  Mem2
//
//  Created by abdiqani on 30/03/23.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    
     var indexN: Int?
    
    var indexD: Int?
    @IBOutlet weak var savedMemeDetail: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let memeUpdated = appDelegate.memes[indexD ?? Int()]
        savedMemeDetail.image = memeUpdated.memedImage // show detail of saved meme
    }
    
    @IBAction func editSavedMeme(_ sender: Any) {
        let editMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        editMemeViewController.savedMemeForEdit = meme // .memedImage
        editMemeViewController.indexE = indexD // pass the index from
        
        navigationController?.present(editMemeViewController, animated: true, completion: nil)
           editMemeViewController.imagePickerView.contentMode = .scaleAspectFill
        
        editMemeViewController.memeIsModified = true
        
    }
    
}

