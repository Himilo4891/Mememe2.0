//
//  ViewController.swift
//  Mem2
//
//  Created by abdiqani on 30/03/23.
//

import UIKit
class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem! // @@@
    
    var savedMemeForEdit: Meme! // to enable editing saved meme in detail view, had to change ? to !
    
    var memeIsModified = false // for done button to show only when already saved memeIsModified
    
    var indexE: Int? // to replace the meme image at given index when editing it
    
    var imagePicker = UIImagePickerController() // an instance of UIImagePickerController
    
    var textField: UITextField!
    
    // MARK: view-DidLoad/willAppear/willDisappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set View Controller as the delegate for the UIImagePickerController
        // denoting that “self” is the delegate for the imagePicker, bottomTextField, topTextField
        imagePicker.delegate = self
        // bottomTextField.delegate = self // need when text style via storyboard
        // topTextField.delegate = self // need when text style via storyboard
        
        // need when text style progamaticaly via method configureTextField(textField: UITextField)
        configureTextField(textField: topTextField,styledDefaultInput: "")
        configureTextField(textField: bottomTextField, styledDefaultInput: "")
        
        // show done button only when already saved memeIsModified = true
        showHideDoneButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false // deleted self. from beggining
   
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
      
        subscribeToKeyboardNotifications()
        
       
        // to enable editing saved meme in detail view
        if let savedMemeForEdit = savedMemeForEdit as Meme? {
            imagePickerView.image = savedMemeForEdit.image
            topTextField.text = savedMemeForEdit.topText
            bottomTextField.text = savedMemeForEdit.bottomText
        }
        showHideDoneButton() // show done button only when already saved memeIsModified = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // call unsubscribeToKeybordNotifications() method in viewWillDissappear
        unsubscribeFromKeybordNotification()
    }

    
    func pickImage(sourceType: UIImagePickerController.SourceType) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        }
    
    // picking an image from Album
    @IBAction func album(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    // taking an image via camera
    @IBAction func camera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imagePickerView.contentMode = .scaleAspectFit // fit view, minimized
            imagePickerView.image = pickedImage // sets the image of the
            
            shareButton.isEnabled = true
            showHideDoneButton()
            dismiss(animated: true, completion: nil) // dismiss image picker after xy image is selected
        }
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // dismiss image picker after button "Cancel" is tapped
    }
    
    // MARK: Text Field Delegate I. - default text to clear when user starts typing
    
    // when a user taps inside the textfiels the default text should clear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "HEADER" || textField.text == "FOOTER" {
            textField.text = ""
        }
    }
    
    // MARK: Text Field Delegate II. - keybord to get down after tapping return/enter
    
    // when a user presses return/enter, the keyboard should be dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Text style in textFields
    
    // configureTextField is declared in viewDidLoad()
    func configureTextField(textField: UITextField, styledDefaultInput: String) {
        let textStyle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Impact", size: 35)!,
            NSAttributedString.Key.strokeWidth: -4]
                as [NSAttributedString.Key : Any]
        
        var styledDefaultInput = "HEADER"
        topTextField.text = styledDefaultInput
        styledDefaultInput = "FOOTER"
        bottomTextField.text = styledDefaultInput
        
        textField.delegate = self
        
        textField.defaultTextAttributes = textStyle
        
       
        textField.borderStyle = .none
        
        textField.keyboardType = .webSearch
        
        textField.autocorrectionType = .no
       
        textField.autocapitalizationType = .allCharacters // why does not work?
        
        textField.adjustsFontSizeToFitWidth = true
        
        textField.textAlignment = .center // or alternative way below, but no need
    }
    
   
    @objc func keybordWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            // view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            view.frame.origin.y = -getKeyboardHeight(notification)
            }
    }
    
    // get keybord height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keybordSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keybordSize.cgRectValue.height
    }
    
    // keybord does hide, frame view is again in original vertical position (y)
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
            }
        }
   
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: unsubscribe
    
    func unsubscribeFromKeybordNotification() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // https://developer.apple.com/documentation/foundation/notification
   
    func generateMemedImage() -> UIImage {
        
        topNavBar.isHidden = true
        toolbar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // MARK: save
    
    func save() {
        
        // get the image from the imagePickerView
        let imageView = imagePickerView.image
        
        // "blend meme"
        let memedImage = generateMemedImage()

        let meme = Meme(topText: topTextField.text ?? String(), bottomText: bottomTextField.text ?? String(), image: imageView ?? UIImage(), memedImage: memedImage ) // with init, see file MemeStruct
        
        // so that I can access appDelegate in the scope of current file
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme) // add the meme to the memes array in the AppDelegate.swift
        
    }
    
    // MARK: share
    
    @IBAction func share(_ sender: Any) {
        
        // "blend meme"
        let memedImage = generateMemedImage()
        
        // define an instance of ActivityViewController
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // so that iPads won't crash
        activityVC.popoverPresentationController?.sourceView = self.view
        
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        // present the VC
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: cancel
    
    // cancel button to reset editor to HEADER,FOOTER, noImage and return user to the Sent Memes View
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        topTextField.text = "HEADER"
        bottomTextField.text = "FOOTER"
        self.imagePickerView.image = nil
        shareButton.isEnabled = false // no picture no share button
        dismiss(animated: true, completion: nil)
    }
    
    // show done button only when already saved memeIsModified = true
    func showHideDoneButton() {
        let showDone = memeIsModified
        doneButton!.tintColor = showDone ? view.tintColor : UIColor.clear
        // doneButton!.isEnabled = show ? true : false // grey font of done becomes blue
    }
        
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        // "blend meme"
        let memedImage = generateMemedImage()
        
        // to put together layers of modified meme, texts, image and final "blended" memedImage
        let memeUpdated = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image ?? UIImage(), memedImage: memedImage) // with init, see file MemeStruct
        
        // so that I can access appDelegate in the scope of current file
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
            appDelegate.memes[indexE ?? Int()] = memeUpdated // to replace the meme image at given index after modifying it

      
        dismiss(animated: true, completion: nil)
        
        
         
    }
    
}







