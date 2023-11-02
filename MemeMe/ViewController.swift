//
//  ViewController.swift
//  MemeMe
//
//  Created by Youda Zhou on 27/9/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    var shouldClearTopTextField = true
    var shouldClearBottomTextField = true
    var memedImage: UIImage!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Notification
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if topTextField.isFirstResponder { return }
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
        
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: Functions
    func initNavigationBar() {
    }
    
    func initTextFields() {
        let memeTextAttributes = getMemeTextAttributes()
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
    }
    
    func getMemeTextAttributes() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.5
        ]
    }
    
    func save() {
        // Create the meme
        let _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)

    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideToolBarAndNavBar()
            
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
        // Show toolbar and navbar
        showToolBarAndNavBar()
        return memedImage
    }
    
    func hideToolBarAndNavBar() {
        self.navigationBar.isHidden = true
        self.toolbar.isHidden = true
    }
    
    func showToolBarAndNavBar() {
        self.navigationBar.isHidden = false
        self.toolbar.isHidden = false
    }
    
    //MARK: Text field delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && shouldClearTopTextField {
            textField.text = ""
            shouldClearTopTextField = false
        }
        
        if textField == bottomTextField && shouldClearBottomTextField {
            textField.text = ""
            shouldClearBottomTextField = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else {
            return
        }
        if textField == topTextField {
            textField.text = "TOP"
        } else if textField == bottomTextField {
            textField.text = "BOTTOM"
        }
    }
    
    //MARK: Image picker controller delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true)
    }

    //MARK: IBActions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        view.endEditing(true)
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        view.endEditing(true)
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let uiimage = generateMemedImage()
        let items = [uiimage]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { type, isCompleted, items, error in
            guard isCompleted else { return }
            self.memedImage = uiimage
            self.save()
        }
        self.present(activityViewController, animated: true)
    }
}

