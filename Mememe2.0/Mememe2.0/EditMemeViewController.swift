//
//  EditMemeViewController.swift
//  Mememe2.0
//
//  Created by abdiqani on 11/01/23.

import Foundation
import UIKit
class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate, UITextFieldDelegate   {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField(textField: topTextField, defaultText:"")
        prepareTextField(textField: bottomTextField, defaultText:"")
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        shareButton.isEnabled = true
        showHideDoneButton()
        imagePicker.delegate = self
#if targetEnvironment(simulator)
        camerButton.isEnabled = false
#else
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera);
#endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        subscribeToKeyBoardNotifications()
        if let savedMemeForEdit = savedMemeForEdit as Meme? {
            imagePickerView.image = savedMemeForEdit.memedImage
            topTextField.text = savedMemeForEdit.topText
            bottomTextField.text = savedMemeForEdit.bottomText
            
        }
        showHideDoneButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyBoardNotifications()
        
    }
        
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var Toolbar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var AlbumButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var camerButton: UIButton!
    
//    @IBOutlet weak var camerButton: UIButton!
    
    //    var memes = [Meme]()
    //    var editMeme : Meme?
    var memeIsModified = false
    
    var savedMemeForEdit: Meme!
    var indexE: Int?
    
    var imagePicker = UIImagePickerController()
    
    var textField: UITextField!
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pickAnImage(UIImagePickerController.SourceType.camera)
    }
    
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
//        let pickerController = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func save() {
        let imageView = imagePickerView.image
        let memedImage = generateMemedImage()
        // Create and save the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image ?? UIImage(), memedImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // !!!! DELETE this
        controller.popoverPresentationController?.sourceView = self.view
        
        controller.completionWithItemsHandler = { controller, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        // KEEP this
        present(controller,animated: true, completion: nil)
    }
    @IBAction func cancelToShareMeme(_ sender: Any) {
        leaveMemeInBetween()
    }
    //To clear texts up on touch
    @IBAction func topTextField(_ sender: Any) {
        textFieldDidBeginEditing(topTextField)
        
        
    }
    
    @IBAction func bottomTextField(_ sender: Any) {
        textFieldDidBeginEditing(bottomTextField)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected")
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            
            shareButton.isEnabled = true
            showHideDoneButton()
            print("share button action is active")
            debugPrint(1...5)
            
        }
        dismiss(animated: true, completion: nil)
    }
    //IF Image picking is cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    //To clear text in text fields when user starts editing
    @objc func textFieldDidBeginEditing(_ textField: UITextField){
        if (textField == topTextField && textField.text == "TOP") || (textField == bottomTextField && textField.text == "BOTTOM"){
            textField.text = " "
        }
    }
    //to dismiss key board when user clicks return
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    //Text in text field specifications
    func prepareTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedString.Key.strokeWidth: -4]
        as [NSAttributedString.Key : Any]
        
        var defaultText = "HEADER"
        topTextField.text = defaultText
        defaultText = "FOOTER"
        bottomTextField.text = defaultText
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
//        textField.borderStyle = .none
//        textField.keyboardType = .webSearch
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .center
    }
    //
    //    func prepareTextField(textField: UITextField, defaultText: String) {
    //        textField.delegate = self
    //        textField.textAlignment = .center
    //        textField.defaultTextAttributes = memeTextAttributes
    //        textField.text = defaultText
    //        textField.autocapitalizationType = .allCharacters
    //
    //    }
        
    
    //Key board settings
    @objc func keyboardWillShow(_ notification:Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    func subscribeToKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    

    
    //Created final MEME
    func generateMemedImage() -> UIImage {
        //Hide tab and nav bars
        self.navigationController?.navigationBar.isHidden = true;
        
        self.tabBarController?.tabBar.isHidden = true;
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()


        return memedImage
    }
    //to adapt user behaviour as discard in between
    func leaveMemeInBetween(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        //cant we make a recursive call?if yes,how!!
        initialState()
    }
    
    func initialState(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
    }
   
    
    func showHideDoneButton() {
        let showDone = memeIsModified
        doneButton!.tintColor = showDone ? view.tintColor : UIColor.clear
        // doneButton!.isEnabled = show ? true : false // grey font of done becomes blue
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
    
        let memedImage = generateMemedImage()
        
        let memeUpdated = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image ?? UIImage(), memedImage: memedImage)
        
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes[indexE ?? Int()] = memeUpdated
        dismiss(animated: true, completion: nil)

        
    }
}
