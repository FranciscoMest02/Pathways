//
//  ContentView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 04/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var trips: [Trip]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Highlighted trips")
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(trips) { trip in
                                NavigationLink(destination: TripDescriptionView(trip: trip)) {
                                    CardView(title: trip.name, photosAmount: trip.imageCount, image: trip.images.first, flag: trip.flag)
                                        .padding(.horizontal)
                                }
                                
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Trips")
            .toolbar {
                NavigationLink(destination: AddingTripView()) {
                    Image(systemName: "airplane")
                        .background(.yellow)
                }
                
                Button {
                    try? modelContext.delete(model: Trip.self)
                } label: {
                    Image(systemName: "trash")
                        .background(.yellow)
                }
                
                Button {
                    try? modelContext.delete(model: Trip.self)
                    
                    let trip1 = Trip(name: "First Time in Rome", country: "Italy", flag: "🇮🇹", text: "Description here...", startDate: .now, endDate: .now, images: [])
                    let trip2 = Trip(name: "Turquish Honey Moon", country: "Turkey", flag: "🇹🇷", text: "Description here...", startDate: .now, endDate: .now, images: [])
                    let trip3 = Trip(name: "Mi first time eating Tacos", country: "Mexico", flag: "🇲🇽", text: "Descripcion here...", startDate: .now, endDate: .now, images: [])
                    
                    modelContext.insert(trip1)
                    modelContext.insert(trip2)
                    modelContext.insert(trip3)
                } label: {
                    Image(systemName: "plus")
                }
//                NavigationLink(destination: EmptyView()) {
//                    Image(systemName: "plus")
//                }
            }
        }
    }
}

#Preview {
    ContentView()
}
