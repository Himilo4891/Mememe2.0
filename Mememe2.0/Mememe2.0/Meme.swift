//
//  Villain.swift
//  BondVillains
//
//  Created by Jason on 11/19/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Villain

struct Meme {
    
    // MARK: Properties
    
    let name: String
    let evilScheme: String
    let imageName: String
    class Meme {
        private var topTextField: String?
        private var bottomTextField: String?
        private var originalImage: UIImage?
        private var memedImage: UIImage?
        
        func addTopTextField(_ topTextField: String)  {
            self.topTextField = topTextField
        }
        
        func addBottomTextField(_ bottomTextField: String) {
            self.bottomTextField = bottomTextField
        }
        
        func addOriginalImage(_ originalImage: UIImage) {
            self.originalImage = originalImage
        }
        
        var hasOriginalImage: Bool {
            return !(originalImage === nil)
        }
        func reset() {
            topTextField = nil
            bottomTextField = nil
            originalImage = nil
        }
        func isValid() -> Bool {
            guard let _ = topTextField,
                  let _ = bottomTextField,
                  let _ = originalImage else {
                
                return false
            }
            
            return topTextField!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
            && bottomTextField!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        }
        func build(_ view: UIView) -> UIImage {
            guard isValid() else {
                fatalError("All properties are required!")
            }
            
            // Render view to an image
            UIGraphicsBeginImageContext(view.frame.size)
            view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            self.memedImage = memedImage
            
            return memedImage
        }
        
        func save() {
            UIImageWriteToSavedPhotosAlbum(memedImage!, nil, nil, nil)
        }
        
        func getTopText() -> String {
            
            return topTextField!
        }
        
        func getBottomText() -> String {
            return bottomTextField!
        }
        
        func getImage() -> UIImage {
            return memedImage!
        }
        
        func getOriginalImage() -> UIImage {
            return originalImage!
        }
        
    }
}
