//
//  AddingTripView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 09/12/24.
//

import PhotosUI
import SwiftUI

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
    @State private var location: String = ""
    @State private var images: [Data] = [Data]()
    
    var body: some View {
        Form {
            TextField("Trip name", text: $title)
            TextField("Description", text: $description)
            TextField("Location", text: $location)
            
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
    
    //Save the trip to SwiftData with the form information
    func saveTrip() {
        let trip = Trip(name: title, country: location, text: description, startDate: startDate, endDate: endDate, images: images)
        modelContext.insert(trip)
        dismiss()
    }
}

#Preview {
    AddingTripView()
}
