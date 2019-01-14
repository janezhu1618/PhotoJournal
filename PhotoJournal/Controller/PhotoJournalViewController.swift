//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Jane Zhu on 1/14/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import UIKit

class PhotoJournalViewController: UIViewController {
    
    @IBOutlet weak var photoJournalCollectionView: UICollectionView!
    @IBOutlet var noEntryView: UIView!
    
    private var photoJournals = [PhotoJournal]() {
        didSet {
            photoJournalCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoJournalCollectionView.dataSource = self
        photoJournalCollectionView.delegate = self
        if let photoJournals = PhotoJournalModel.getPhotoJournal() {
            self.photoJournals = photoJournals

        }
        if photoJournals.isEmpty {
            photoJournalCollectionView.backgroundView = noEntryView
        }
        print("we have \(photoJournals.count)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }


}

extension PhotoJournalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoJournals.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoJournalCollectionView.dequeueReusableCell(withReuseIdentifier: "JournalCell", for: indexPath) as? JournalCell
            else { fatalError("JournalCell not found") }
        if photoJournals.isEmpty {
            print("empty")
        } else {
        let journalToSet = photoJournals[indexPath.row]
        cell.journalCaption.text = journalToSet.caption
        cell.journalTimeStamp.text = journalToSet.lastUpdated
        cell.journalImageView.image = UIImage(named: "placeHolder")
        }
        return cell
    }
}

extension PhotoJournalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 600)
    }
}
