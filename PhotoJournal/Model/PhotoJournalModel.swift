//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Jane Zhu on 1/14/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import UIKit

struct PhotoJournalModel {
    private static let filename = "PhotoJournal.plist"
    private static var photoJournals = [PhotoJournal]()
    
    static func getPhotoJournal() -> [PhotoJournal] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path

        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photoJournals = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    print("property list decoding error getPhotoJournal() \(error)")
                }
            } else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("\(filename) file does not exist")
        }
        //photoJournals = photoJournals.sorted{ $0.date > $1.date }
        return photoJournals
    }
    
    static func addJournal(photoJournal: PhotoJournal) {
        photoJournals.append(photoJournal)
        save()
    }
    
    
    static func save() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photoJournals)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error: \(error)")
        }
    }
    
    static func deleteJournal(atIndex: Int) {
        photoJournals.remove(at: atIndex)
        save()
    }
    
    
}
