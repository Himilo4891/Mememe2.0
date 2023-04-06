//
//  AppDelegate.swift
//  Mememe2.0
//
//  Created by abdiqani on 11/01/23.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    var memes = [Meme]()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UIToolbar.appearance().setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any);
        return true
    }
    
    
    
}
