//
//  SentMemesViewController.swift
//  MemeMeV1
//
//  Created by selin acar on 2016-08-08.
//  Copyright © 2016 Selin Denise Acar. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController{

    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Meme", style: .Plain, target: self, action: #selector(SentMemesTableViewController.PushMemeCreatorVC))
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    func setBackground(){
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "backgroundImage.png")
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.center = self.view.center
        self.tableView.backgroundView = backgroundImageView
    }
    
    func PushMemeCreatorVC(){
        let memeGeneratorVC = self.storyboard?.instantiateViewControllerWithIdentifier("generateVC") as! GenerateMemeViewController
        self.navigationController?.pushViewController(memeGeneratorVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath)
        cell.imageView?.contentMode = .ScaleAspectFill
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.textLabel?.text = memes[indexPath.row].topText + "|" + memes[indexPath.row].bottomText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sentMemeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemeDetail") as! SentMemeDetailViewController
        sentMemeDetailVC.meme = memes[indexPath.row]
        self.navigationController?.showViewController(sentMemeDetailVC, sender: nil)
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50.0)
    }
    
}
