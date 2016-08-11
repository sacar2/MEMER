//
//  SentMemeDetailViewController.swift
//  MemeMeV1
//
//  Created by selin acar on 2016-08-09.
//  Copyright © 2016 Selin Denise Acar. All rights reserved.
//

import UIKit

class SentMemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    var meme: Meme!
    var navigationBarIsHidden: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = meme.memedImage
        UIApplication.sharedApplication().statusBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = false
        self.tabBarController?.tabBar.hidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SentMemeDetailViewController.imageTapped))
        memeImage.userInteractionEnabled = true
        memeImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(img: AnyObject){
        navigationBarIsHidden = !navigationBarIsHidden
        if navigationBarIsHidden{
            changeBackgroundColour(UIColor.blackColor())
        }else{
            changeBackgroundColour(UIColor.whiteColor())
        }
        self.navigationController?.navigationBar.hidden = navigationBarIsHidden
    }
    
    func changeBackgroundColour(color: UIColor){
        self.view.backgroundColor = color
    }
    
}
