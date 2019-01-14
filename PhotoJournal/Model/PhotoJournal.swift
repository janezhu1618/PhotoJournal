//
//  PhotoJournal.swift
//  PhotoJournal
//
//  Created by Jane Zhu on 1/14/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import Foundation

struct PhotoJournal: Codable {
    let lastUpdated: String
    let caption: String
    let imageData: Data
}
