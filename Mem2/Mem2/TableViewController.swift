//
//  TableViewController.swift
//  Mem2
//
//  Created by abdiqani on 30/03/23.
//

import Foundation
import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeTitleLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    
    
}

class TableViewController: UITableViewController {
    
    @IBAction func unwindToMemeTableViewController(segue: UIStoryboardSegue) {}
    
    @IBOutlet var table: UITableView!
    
   
    var memes: [Meme] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
    
        cell.memeImageView?.image = meme.memedImage
        cell.memeTitleLabel?.text = meme.topText + " " + meme.bottomText
        tableView.separatorColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.item]
        detailController.indexD = indexPath.row // to change an array need its index, see MemeDetailVC
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // swipe to delete table row part-a
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // swipe to delete table row part-b
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            appDelegate.memes.remove(at: indexPath.row)
        }
        
    }
    @IBOutlet var sortButton: UIBarButtonItem!
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let selectedItem = memes[sourceIndexPath.row]
        memes.remove(at: sourceIndexPath.row)
        memes.insert(selectedItem, at: destinationIndexPath.row)
      
        appDelegate.memes.remove(at: sourceIndexPath.row)
        appDelegate.memes.insert(selectedItem, at: destinationIndexPath.row)
        
    }
    
}
