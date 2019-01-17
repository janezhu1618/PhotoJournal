//
//  JournalEntryViewController.swift
//  PhotoJournal
//
//  Created by Jane Zhu on 1/14/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import UIKit
import AVKit

class JournalImagePickerViewController: UIViewController {

    @IBOutlet weak var journalCaptionTextView: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var journalPhoto: UIImageView!
    var photoJournal: PhotoJournal?
    var indexNumber = 0
    
    private var imagePickerViewController: UIImagePickerController!
    private var journalCaptionPlaceHolder = "Type in your caption..."
    
    fileprivate func setUpJournalDetailViewController() {
        if let photoJournal = photoJournal {
            journalCaptionTextView.text = photoJournal.caption
            journalCaptionTextView.textColor = .black
            if let image = UIImage(data: photoJournal.imageData) {
                journalPhoto.image = image
            }
        } else {
            journalCaptionTextView.text = journalCaptionPlaceHolder
            journalCaptionTextView.textColor = .darkGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        journalCaptionTextView.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        setUpJournalDetailViewController()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate,
                                          .withFullTime,
                                          .withInternetDateTime,
                                          .withTimeZone,
                                          .withDashSeparatorInDate]
        let timeStamp = isoDateFormatter.string(from: date)
        if let _ = photoJournal {
            if let imageExists = journalPhoto.image, let photoCaption = journalCaptionTextView.text {
                if let imageData = imageExists.jpegData(compressionQuality: 0.5) {
                    let photoJournal = PhotoJournal.init(lastUpdated: timeStamp, caption: photoCaption, imageData: imageData)
                PhotoJournalModel.updateJournal(photoJournal: photoJournal, atIndex: indexNumber)
            }
            }
        } else {
            if let imageExists = journalPhoto.image {
                if let imageData = imageExists.jpegData(compressionQuality: 0.5), let photoCaption = journalCaptionTextView.text {
                let photoJournal = PhotoJournal.init(lastUpdated: timeStamp, caption: photoCaption, imageData: imageData)
                PhotoJournalModel.addJournal(photoJournal: photoJournal)
            }
        }
        }
        dismiss(animated: true, completion: nil)
    }

    
    private func showImagePickerViewController() {
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .photoLibrary
        showImagePickerViewController()
        
    }
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .camera
        showImagePickerViewController()
    }
    
    private func displayPhoto(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.5){
            if let validImage = UIImage(data: imageData) {
                journalPhoto.image = validImage
            }
        }
    }
}

extension JournalImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            journalPhoto.image = image
            displayPhoto(image: image)
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension JournalImagePickerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if journalCaptionTextView.text == journalCaptionPlaceHolder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if journalCaptionTextView.text == "" {
            textView.text = journalCaptionPlaceHolder
            textView.textColor = .darkGray
        }
    }
}
