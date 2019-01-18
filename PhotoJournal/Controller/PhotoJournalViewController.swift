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
    @IBOutlet weak var searchBar: UISearchBar!

    private var refreshControl: UIRefreshControl!
    
    @objc private func fetchJournals() {
        refreshControl.endRefreshing()
        getPhotoJournals()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        photoJournalCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchJournals), for: .valueChanged)
    }
    
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
        searchBar.delegate = self
        photoJournalCollectionView.dataSource = self
        photoJournalCollectionView.delegate = self
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPhotoJournals()
    }
    
    private func shareJournal(atIndex: Int) {
        if let imageToShare = UIImage(data: photoJournals[atIndex].imageData) {
            let captionToShare = photoJournals[atIndex].caption
        let activityViewController = UIActivityViewController(activityItems: [imageToShare, captionToShare], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
    
    private func deleteJournal(atIndex: Int) {
        PhotoJournalModel.deleteJournal(atIndex: atIndex)
    }
    
    private func editJournal(atIndex: Int) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "JournalDetails") as? JournalImagePickerViewController else { return }
        destinationViewController.modalPresentationStyle = .currentContext
        destinationViewController.photoJournal = photoJournals[atIndex]
        destinationViewController.indexNumber = atIndex
        present(destinationViewController, animated: true, completion: nil)
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "What would you like to do with this journal entry?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.deleteJournal(atIndex: sender.tag)
            self.getPhotoJournals()
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            self.editJournal(atIndex: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            self.shareJournal(atIndex: sender.tag)
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
        guard let cell = photoJournalCollectionView.dequeueReusableCell(withReuseIdentifier: "JournalCell", for: indexPath) as? JournalCell else { return UICollectionViewCell() }
        let journalToSet = photoJournals[indexPath.row]
        cell.journalCaption.text = journalToSet.caption
        cell.journalTimeStamp.text = journalToSet.dateFormattedString
        cell.journalOptionsButton.tag = indexPath.row // sender.tag is now equivalent to the index number
        if let image = UIImage(data: journalToSet.imageData) {
            cell.journalImageView.image = image
        }
        return cell
    }
}

extension PhotoJournalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 500)
    }
}

extension PhotoJournalViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        photoJournals = photoJournals.filter{ $0.caption.lowercased().contains(searchText.lowercased())}
    }
}

