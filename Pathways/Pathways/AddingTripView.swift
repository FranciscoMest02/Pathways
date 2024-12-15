//
//  AddingTripView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 09/12/24.
//

import CoreLocation
import ImageIO
import PhotosUI
import SwiftUI
import MapKit
import UIKit

struct AddingTripView: View {
    //Navigation dismiss variable
    @Environment(\.dismiss) var dismiss
    
    //SwiftData
    @Environment(\.modelContext) var modelContext
    
    //PhotosUI vars for logic
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    //Variables for trip form
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    @State private var location: (name: String, flag: String) = (name: "", flag: "")
    @State private var images: [Data] = [Data]()
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    
    var body: some View {
        Form {
            TextField("Trip name", text: $title)
            TextField("Description", text: $description)
            
            DatePicker(selection: $startDate, displayedComponents: .date) {
                Text("Start day")
            }
            
            DatePicker(selection: $endDate, displayedComponents: .date) {
                Text("End day")
            }
            
            CountrySelectionView(selectedCountry: $location)
                .onChange(of: location.name) { oldValue, newValue in
                    Task {
                        let coordinates = await getCoordinates(for: newValue)
                        latitude = coordinates?.latitude ?? 0
                        longitude = coordinates?.longitude ?? 0
                    }
                }
            
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                Image(systemName: "photo")
            }
            .onChange(of: selectedItems) {
                Task {
                    await loadImages()
                }
            }
            
            Section {
                Button("Save trip", action: saveTrip)
            }
            
            ForEach(0..<selectedImages.count, id: \.self) { i in
                selectedImages[i]
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    func loadImages() async {
        for item in selectedItems {
            do {
                if let imageData = try await item.loadTransferable(type: Data.self) {
                    guard let resizedData = UIImage.resizeImageData(imageData: imageData, targetLongSide: 350) else {
                        print("Failed to resize image data.")
                        continue
                    }

                    // Convert resized data to UIImage and append it to the array
                    if let uiImage = UIImage(data: resizedData) {
                        images.append(resizedData)
                        
                        print("Final image size: \(uiImage.size)")

                        // Convert UIImage to SwiftUI Image and append to selectedImages
                        let loadedImage = Image(uiImage: uiImage)
                        selectedImages.append(loadedImage)
                    }

                    // Extract and handle metadata
                    if let metadata = extractMetadata(from: imageData) {
                        print(metadata)

                        if let coordinates = extractGPSCoordinates(from: metadata) {
                            print("Got coordinates \(coordinates)")

                            reverseGeocode(latitude: coordinates.latitude, longitude: coordinates.longitude) { country in
                                if let country = country {
                                    print("Image was taken in \(country).")
                                } else {
                                    print("Unable to determine country.")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error loading transferable: \(error)")
            }
        }
    }
    
    func extractMetadata(from data: Data) -> [String: Any]? {
            guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                print("Failed to create image source.")
                return nil
            }

            if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] {
                return properties
            } else {
                print("Failed to extract metadata.")
                return nil
            }
        }
    
    func getCoordinates(for location: String) async -> (latitude: Double, longitude: Double)? {
        guard !location.isEmpty else { return nil }
        
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(location)
            if let placemark = placemarks.first, let location = placemark.location {
                return (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            } else {
                print("No location found")
                return nil
            }
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    //THIS FUNCTION IS FOR THE PENDING METADATA
    func extractGPSCoordinates(from metadata: [String: Any]) -> (latitude: Double, longitude: Double)? {
        guard let gpsData = metadata["{GPS}"] as? [String: Any],
              let latitude = gpsData["Latitude"] as? Double,
              let latitudeRef = gpsData["LatitudeRef"] as? String,
              let longitude = gpsData["Longitude"] as? Double,
              let longitudeRef = gpsData["LongitudeRef"] as? String else {
            return nil
        }

        let lat = latitudeRef == "S" ? -latitude : latitude
        let lon = longitudeRef == "W" ? -longitude : longitude
        return (latitude: lat, longitude: lon)
    }
    
    //THIS FUNCTION IS FOR THE PENDING METADATA
    func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                let country = placemark.country // Country name
                let locality = placemark.locality // City or town
                let placeType = placemark.areasOfInterest?.first // Landmark or area of interest
                print("Country: \(country ?? "Unknown"), Locality: \(locality ?? "Unknown"), Place Type: \(placeType ?? "Unknown")")
                completion(country) // Return country as an example
            } else {
                completion(nil)
            }
        }
    }

    
    //Save the trip to SwiftData with the form information
    func saveTrip() {
        let trip = Trip(name: title, country: location.name, flag: location.flag, text: description, startDate: startDate, endDate: endDate, images: images, latitude: latitude, longitude: longitude)
        modelContext.insert(trip)
        dismiss()
    }
}

#Preview {
    AddingTripView()
}
