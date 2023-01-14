import Foundation
import UIKit
class CollectionViewController: UICollectionViewController {
    
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1.0
        let dimension = (view.frame.size.width - (2 * space)) / 1.5
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 1
   }
    
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

           
            let meme = memes[(indexPath as NSIndexPath).row]
            cell.labelView.text = meme.name
            cell.imageView?.image = UIImage(named: meme.imageName)
            
            return cell

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func memeSegue(_ sender: Any) {
           
           let controller = storyboard?.instantiateViewController(identifier: "MemeController") as! ViewController
           controller.modalPresentationStyle = .fullScreen
           present(controller, animated: true, completion: nil)
       }
    
    
}
