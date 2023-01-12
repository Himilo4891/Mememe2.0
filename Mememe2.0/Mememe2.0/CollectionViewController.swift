import Foundation
import UIKit

class CollectionViewController: UIViewController {
    
    var memes = [Meme]()
    
    // MARK: Outlets
    
   
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        memes = getMemes()
        
    }
    
    // Setup Navigation Bar
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
    }
    
    // Retrieve Saved Memes
    private func getMemes() -> [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Add the setup for the collection view
    
    
    // Setup Flow Layout
    private func setupFlowLayout(){
        let space: CGFloat = 2.0
        let dimension = (view.frame.size.width - (2*space)) / 3.0
        
        // Size between items within a row or column
        flowLayout.minimumInteritemSpacing = space
        // Size between rows or columns
        flowLayout.minimumLineSpacing = space
        // Size of your cells:
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // Call the Editor view controller
    @objc func createMeme() {
            let ViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.navigationController?.pushViewController(ViewController, animated: true)
    }

}
    
    // MARK: Collection View Setup
    

        // Collection View Data Source
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        // Returns the amount of itens in collection
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
        }
        
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            
            //Configure the cell
            let meme = memes[(indexPath as NSIndexPath).row]
            
            //Set the image
//            cell.imageView.image = Meme.memes
            cell.labelView.text = meme.name
            cell.imageView?.image = UIImage(named: meme.imageName)
            return cell
            
        }
    
    
        
        // Collection View Delegate
        
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            
    detailController.meme = memes[(indexPath as NSIndexPath).row]
            
            
            self.navigationController!.pushViewController(detailController, animated: true)
     
        }
}

