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

    fileprivate func getPhotoJournals() {
        photoJournals = PhotoJournalModel.getPhotoJournal()
        if photoJournals.isEmpty {
            photoJournalCollectionView.backgroundView = noEntryView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotoJournals()
        photoJournalCollectionView.dataSource = self
        photoJournalCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPhotoJournals()
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "What would you like to do with the journal entry?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            print("user clicked share \(sender.tag)")
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            print("user clicked edit \(sender.tag)")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            print("user clicked delete \(sender.tag)")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
        cell.journalTimeStamp.text = journalToSet.dateFormattedString
        if let image = UIImage(data: journalToSet.imageData) {
            cell.journalImageView.image = image
            }
        }

        return cell
    }
}

extension PhotoJournalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 500)
    }
}
