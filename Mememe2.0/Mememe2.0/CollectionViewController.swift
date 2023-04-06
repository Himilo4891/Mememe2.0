//
//  CollectionViewController.swift
//  Mememe2.0
//
//  Created by abdiqani on 11/01/23.
import Foundation
import UIKit

class CollectionViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        // set Collection Constraints
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 118, height: 118)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // for drag&drop
        collectionView.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView ?? UICollectionView())
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView?.addGestureRecognizer(gesture)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes
//        setupNavigationBar()
//        memes = getMemes()
        collectionView.reloadData()
        
    }
    
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
       
        cell.imageView?.image = meme.memedImage
        
        return cell
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.item]
        detailController.indexD = indexPath.row
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        // unwrap collection view
        guard let collectionView = collectionView else {
            return
        }
        
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
                
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 118)
    }
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let draggedItem = memes.remove(at: sourceIndexPath.row)
        memes.remove(at: sourceIndexPath.row)
        memes.insert(draggedItem, at: destinationIndexPath.row)
        
        // so that re-order changes are reflected also in collection, apply shared model object memes
        appDelegate.memes.remove(at: sourceIndexPath.row)
        appDelegate.memes.insert(draggedItem, at: destinationIndexPath.row)
        
    }
}
