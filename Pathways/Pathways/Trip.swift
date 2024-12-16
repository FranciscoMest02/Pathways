//
//  Trip.swift
//  Pathways
//
//  Created by Francisco Mestizo on 05/12/24.
//

import Foundation
import SwiftData
import MapKit

@Model
class Trip {
    var name: String
    var country: String
    var flag: String = ""
    var text: String
    var startDate: Date
    var endDate: Date
    var images: [Data] = [Data]()
    var imageCount: Int { images.count }
    var latitude: Double = 0
    var longitude: Double = 0
    
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
    
    var totalDays: Int {
        let strippedStartDate = Calendar.current.startOfDay(for: startDate)
        let strippedEndDate = Calendar.current.startOfDay(for: endDate)
        let components = Calendar.current.dateComponents([.day], from: strippedStartDate, to: strippedEndDate)
        return (components.day ?? 0) + 1
    }
    
    init(name: String, country: String, flag:String, text: String, startDate: Date, endDate: Date, images: [Data] = [], latitude: Double = 0.0, longitude: Double = 0.0) {
        self.name = name
        self.country = country
        self.flag = flag
        self.text = text
        self.startDate = startDate
        self.endDate = endDate
        self.images = images
        self.latitude = latitude
        self.longitude = longitude
    }
}
