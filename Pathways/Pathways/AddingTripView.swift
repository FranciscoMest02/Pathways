//
//  AddingTripView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 09/12/24.
//

import PhotosUI
import SwiftUI
import MapKit

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
    
    //Loads the images received from the PhotosPicker
    func loadImages() async {
        for item in selectedItems {
            if let imageData = try? await item.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: imageData) {
                    let loadedImage = Image(uiImage: uiImage)
                    selectedImages.append(loadedImage)
                    
                    images.append(imageData)
                }
            }
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
