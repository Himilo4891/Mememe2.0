
//TableViewController.swift
//  Mememe2.0
//
//  Created by abdiqani on 11/01/23.

import UIKit
class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    // MARK: Life Cycle
    
    @IBOutlet var Table: UITableView!
    
    @IBOutlet var sortButton: UIBarButtonItem!
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Table.dataSource = self
        Table.delegate = self
        memes = appDelegate.memes
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    //    func sections(in tableview: UITableView) -> Int {
    ////        return 1
    //    }
    
  
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
        
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            let meme = self.memes[(indexPath as NSIndexPath).row]
            
            cell.memeTitle.text = meme.topText + " " + meme.bottomText
            cell.memeImage?.image = meme.memedImage
            tableView.separatorColor = UIColor.black
            
            return cell
        }
        
      override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailController.meme = self.memes[indexPath.item]
            detailController.indexD = indexPath.row
            
            self.navigationController!.pushViewController(detailController, animated: true)
            
        }
        
       override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                memes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                appDelegate.memes.remove(at: indexPath.row)
            }
            
        }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let selectedItem = memes[sourceIndexPath.row]
        memes.remove(at: sourceIndexPath.row)
        memes.insert(selectedItem, at: destinationIndexPath.row)
        
        // so that re-order changes are reflected also in collection, apply shared model object memes
        appDelegate.memes.remove(at: sourceIndexPath.row)
        appDelegate.memes.insert(selectedItem, at: destinationIndexPath.row)
        
    }
}

