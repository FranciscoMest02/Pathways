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
    var imageCount: Int { images.count }
    
    var formattedStartDate: String {
        //We verify if the start date is not in the same year as the end, so we dont repeat the year when displayed
        if Calendar.current.component(.year, from: startDate) == Calendar.current.component(.year, from: endDate) {
            return startDate.formatted(.dateTime.month(.abbreviated).day(.defaultDigits))
        } else {
            return startDate.formatted(.dateTime.year().month(.abbreviated).day(.defaultDigits))
        }
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
