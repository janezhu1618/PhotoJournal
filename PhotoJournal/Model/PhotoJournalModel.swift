//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Jane Zhu on 1/14/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import Foundation

struct PhotoJournalModel {
    static let filename = "PhotoJournal.plist"
    
    static func savePhotoJournal(photoJournal: PhotoJournal) {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photoJournal)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error: \(error)")
        }
    }
    
    static func getPhotoJournal() -> [PhotoJournal]? {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        var photoJournals: [PhotoJournal]?
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photoJournals = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    print("property list decoding error getPhotoJournal()")
                }
            } else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("\(filename) file does not exist")
        }
        return photoJournals
    }
    
    
}
