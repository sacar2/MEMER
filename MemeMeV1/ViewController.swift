//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Selin Denise Acar on 2016-07-25.
//  Copyright © 2016 Selin Denise Acar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var MemeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var TopToolBar: UIToolbar!
    @IBOutlet weak var BottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var currenttextfield: Bool?
    
    let MemeTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont(name: "Impact", size: 40.0)!,
        NSStrokeWidthAttributeName: -3.0,
        NSBackgroundColorAttributeName: UIColor.clearColor()
    ]
    
    struct Meme{
        var topText: String = ""
        var bottomText: String = ""
        var originalImage: UIImage?
        var memedImage: UIImage?
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsuscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        topTextField.defaultTextAttributes = MemeTextAttributes
        bottomTextField.defaultTextAttributes = MemeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        shareButton.enabled = false
    }

    @IBAction func PickImageFromCameraRoll(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func CameraToTakeImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            MemeImageView.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textFieldShouldClear(textField)
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if textField == topTextField{
            currenttextfield = false
        }else if textField == bottomTextField{
            currenttextfield = true
        }
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
            return true
        }else{
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)) , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsuscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        view.frame.origin.y = 0
        if currenttextfield == true{
            view.frame.origin.y -= getkeyboardHeight(notification)
        }
    }
    
    func getkeyboardHeight(notification: NSNotification)->CGFloat{
        let info = notification.userInfo
        let keyboardSize = info![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    func generateMeme()->UIImage{
        TopToolBar.hidden = true
        BottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        TopToolBar.hidden = false
        BottomToolbar.hidden = false
        
        return meme
    }
    
    @IBAction func ShareMeme(sender: AnyObject) {
        let memeImg = generateMeme()
        let activityVC = UIActivityViewController(activityItems: [memeImg], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if (!completed) {
                return
            }else{
                self.save(memeImg)
            }
        }
    }
    
    func save(memeImg: UIImage){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:             MemeImageView.image, memedImage: memeImg)
    }
    
    @IBAction func CancelMeme(sender: AnyObject) {
        MemeImageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
    }
    
    
}

