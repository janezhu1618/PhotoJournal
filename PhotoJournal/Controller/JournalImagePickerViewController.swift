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

    @IBOutlet weak var journalDetailTextView: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var journalPhotoCaptionTextView: UITextView!
    @IBOutlet weak var journalPhoto: UIImageView!
    
    private var imagePickerViewController: UIImagePickerController!
    private var journalCaptionPlaceHolder = "Type in your caption..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        journalPhotoCaptionTextView.delegate = self
        journalPhotoCaptionTextView.text = journalCaptionPlaceHolder
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
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
        if let imageExists = journalPhoto.image {
            if let imageData = imageExists.jpegData(compressionQuality: 0.5), let photoCaption = journalPhotoCaptionTextView.text {
                let photoJournal = PhotoJournal.init(lastUpdated: timeStamp, caption: photoCaption, imageData: imageData)
            PhotoJournalModel.addJournal(photoJournal: photoJournal)
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
        if journalPhotoCaptionTextView.text == journalCaptionPlaceHolder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if journalPhotoCaptionTextView.text == "" {
            textView.text = journalCaptionPlaceHolder
            textView.textColor = .darkGray
        }
    }
}
