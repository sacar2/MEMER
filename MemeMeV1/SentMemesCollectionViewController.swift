//
//  MemeCollectionViewController.swift
//  MemeMeV1
//
//  Created by selin acar on 2016-08-09.
//  Copyright © 2016 Selin Denise Acar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemeCell"

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Meme", style: .Plain, target: self, action: #selector(SentMemesCollectionViewController.PushMemeCreatorView))
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayout()
        setBackground()
    }
    
    func setBackground(){
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "backgroundImage.png")
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.center = self.view.center
        self.collectionView?.backgroundView = backgroundImageView
    }
    
    
    func setFlowLayout(){
        let spacing: CGFloat = 3.0
        let length: CGFloat = (self.view.frame.width - (2*spacing))/3.0
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: length, height: length)
    }
    
    func PushMemeCreatorView(){
        let MemeCreatorVC = self.storyboard?.instantiateViewControllerWithIdentifier("generateVC") as! GenerateMemeViewController
        self.navigationController?.pushViewController(MemeCreatorVC, animated: true)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memeImage.image = memes[indexPath.row].memedImage
        cell.memeImage.contentMode = .ScaleAspectFill
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemeDetail") as! SentMemeDetailViewController
        detailVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
