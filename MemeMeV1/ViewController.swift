//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Selin Denise Acar on 2016-07-25.
//  Copyright © 2016 Selin Denise Acar. All rights reserved.
//

import UIKit

struct Meme{
    var topText: String = ""
    var bottomText: String = ""
    var originalImage: UIImage?
    var memedImage: UIImage?
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var currenttextfield: Bool?
    
    let MemeTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont(name: "Impact", size: 40.0)!,
        NSStrokeWidthAttributeName: -3.0,
        NSBackgroundColorAttributeName: UIColor.clearColor()
    ]
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsuscribeFromKeyboardNotifications()
    }
    
    func configureTextField(textField: UITextField){
        textField.defaultTextAttributes = MemeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    func resetTextFieldTextsToDefault(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        configureTextField(topTextField)
        configureTextField(bottomTextField)
        resetTextFieldTextsToDefault()
        shareButton.enabled = false
    }

    @IBAction func PickImageFromCameraRoll(sender: AnyObject) {
        setupImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func CameraToTakeImage(sender: AnyObject) {
        setupImagePicker(UIImagePickerControllerSourceType.Camera)
    }
    
    func setupImagePicker(sourcetype: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourcetype
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
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
        if currenttextfield == true{
            view.frame.origin.y = 0 - getkeyboardHeight(notification)
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
    
    func hideToolBars(hide: Bool){
        topToolBar.hidden = hide
        bottomToolBar.hidden = hide
    }
    
    func generateMeme()->UIImage{
        hideToolBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        hideToolBars(false)
        return meme
    }
    
    @IBAction func ShareMeme(sender: AnyObject) {
        let memeImg = generateMeme()
        let activityVC = UIActivityViewController(activityItems: [memeImg], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            if (completed) {
                self.save(memeImg)
            }else{
                return
            }
        }
    }
    
    func save(memeImg: UIImage){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:             memeImageView.image, memedImage: memeImg)
    }
    
    @IBAction func CancelMeme(sender: AnyObject) {
        memeImageView.image = nil
        resetTextFieldTextsToDefault()
        shareButton.enabled = false
    }
    
    
}

