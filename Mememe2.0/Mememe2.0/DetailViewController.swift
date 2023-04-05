//
//  DetailViewController.swift
//  Mememe2.0
//
//  Created by abdiqani on 11/01/23.
//
import Foundation
import UIKit
class DetailViewController: UIViewController {
    
    var meme: Meme!
    
    var indexD: Int?
    
    @IBOutlet weak var memeImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let memeUpdated = appDelegate.memes[indexD ?? Int()]
        memeImage.image = memeUpdated.memedImage
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func editSavedMeme(_ sender: Any) {
        let editMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        
        editMemeViewController.savedMemeForEdit = meme
        editMemeViewController.indexE = indexD
        
        navigationController?.present(editMemeViewController, animated: true, completion: nil)
        editMemeViewController.imagePickerView.contentMode = .scaleAspectFill
        
        editMemeViewController.memeIsModified = true

    }
    
}
