import UIKit

class TableViewController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate {
    
    // MARK: - Properties
    
    var memes = [Meme]()
    // MARK: Life Cycle
    @IBOutlet weak var tableView: UITableView!
       
       // MARK: Life Cycle
       override func viewDidLoad() {
           super.viewDidLoad()
           setupTableView()
           setupNavigationBar()
           memes = getMemes()
           tableView.reloadData()
       }
      
    override func viewWillAppear(_ animated: Bool) {
           setupNavigationBar()
           memes = getMemes()
           tableView.reloadData()
       }
      
      // Retrive saved memes
      private func getMemes() -> [Meme] {
          let object = UIApplication.shared.delegate
          let appDelegate = object as! AppDelegate
          return appDelegate.memes
      }
      
      // Setup navigation bar
      private func setupNavigationBar() {
          navigationController?.isNavigationBarHidden = false
          self.tabBarController?.tabBar.isHidden = false
          navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
      }
      
    // Add the setup for the table view
      private func setupTableView() {
          tableView.delegate = self
          tableView.delegate = self
      }
      
     // Call the create meme view controller
      @objc func createMeme() {
          let editorViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditorViewController") as! ViewController
          
          self.navigationController?.pushViewController(editorViewController, animated: true)
      }
  }
      
      //MARK: Table View Setup
      
 
      extension TableViewController: UICollectionViewDelegate, UITableViewDataSource {
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return memes.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell") as! TableViewCell
          let meme = memes[(indexPath as NSIndexPath).row]
          
          cell.memeTitle.text = meme.name
          cell.memeImage?.image = UIImage(named: meme.imageName)
          
          
          return cell
      }
      
      // Delegate
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          // Grab the DetailVC from Storyboard
          let detailController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
          
          // Populate view controller with data from the selected item
         
          let meme = memes[(indexPath as NSIndexPath).row]
         
          //Present the view controller using navigation
          self.navigationController!.pushViewController(detailController, animated: true)
          
      }
  }
