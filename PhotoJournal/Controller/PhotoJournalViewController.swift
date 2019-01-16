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
    
    private var photoJournalIndexNumber = 0
    
    private var photoJournals = PhotoJournalModel.getPhotoJournal() {
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
    
    private func shareJournal() {
        if let imageToShare = UIImage(data: photoJournals[photoJournalIndexNumber].imageData) {
            let image = imageToShare
            let captionToShare = photoJournals[photoJournalIndexNumber].caption
        let activityViewController = UIActivityViewController(activityItems: [image, captionToShare], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
    
    private func deleteJournal() {
        PhotoJournalModel.deleteJournal(atIndex: photoJournalIndexNumber)
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "What would you like to do with this journal entry?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.deleteJournal()
            self.getPhotoJournals() 
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "JournalDetails") as? JournalImagePickerViewController else { return }
            destinationViewController.modalPresentationStyle = .currentContext
            destinationViewController.photoJournal = self.photoJournals[self.photoJournalIndexNumber]
            destinationViewController.indexNumber = self.photoJournalIndexNumber
            self.present(destinationViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            self.shareJournal()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoJournalIndexNumber = indexPath.row
        print(photoJournalIndexNumber)
    }
}
