//
//  PhotoJournal.swift
//  PhotoJournal
//
//  Created by Jane Zhu on 1/14/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import Foundation

struct PhotoJournal: Codable {
    var lastUpdated: String
    let caption: String
    let imageData: Data
    public var dateFormattedString: String {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = lastUpdated
        if let date = isoDateFormatter.date(from: lastUpdated) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy @ hh:mm a"
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }
    
    public var date: Date {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = Date()
        if let date = isoDateFormatter.date(from: lastUpdated) {
            formattedDate = date
        }
        return formattedDate
    }
}
