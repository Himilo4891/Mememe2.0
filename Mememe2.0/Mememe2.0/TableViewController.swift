
import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var memes: [Meme] {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  return appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
                  let meme = memes[(indexPath as NSIndexPath).row]
        
                  cell.memeTitle.text = meme.name
                  cell.memeImage?.image = UIImage(named: meme.imageName)
        
        
                  return cell
              }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController =  storyboard?.instantiateViewController(withIdentifier: "DetailController") as! DetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func memeSegue(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}
