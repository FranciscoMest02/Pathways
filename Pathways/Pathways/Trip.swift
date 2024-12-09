//
//  Trip.swift
//  Pathways
//
//  Created by Francisco Mestizo on 05/12/24.
//

import Foundation
import SwiftData

@Model
class Trip {
    var name: String
    var country: String
    var text: String
    var startDate: Date
    var endDate: Date
    var images: [Data] = [Data]()
    
    var formattedStartDate: String {
        startDate.formatted(date: .abbreviated, time: .omitted)
    }
    var formattedEndDate: String {
        endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    init(name: String, country: String, text: String, startDate: Date, endDate: Date, images: [Data] = []) {
        self.name = name
        self.country = country
        self.text = text
        self.startDate = startDate
        self.endDate = endDate
        self.images = images
    }
}
