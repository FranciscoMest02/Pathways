//
//  TripDescriptionView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 05/12/24.
//

import SwiftUI
import MapKit

struct TripDescriptionView: View {
    let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible())
    ]
    
    var trip: Trip
    var position: MapCameraPosition
    var markerPosition: CLLocationCoordinate2D
    
    var body: some View {
        ScrollView() {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    if trip.imageCount > 0 {
                        if let uiImage = UIImage(data: trip.images.first!) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()
                        }
                    } else {
                        Image("TripImage")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    }
                    
                    LinearGradient(colors: [.black, .black.opacity(0), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                    
                    VStack {
                        Text(trip.name)
                            .foregroundStyle(.white)
                            .font(.largeTitle.bold())
                        
                        Text("\(trip.formattedStartDate) - \(trip.formattedEndDate)")
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 30)
                    
                }
                
                    
                VStack(alignment: .leading) {
                    Text(trip.text)
                        .padding(.top, 24)
                    
                    Map(initialPosition: position, interactionModes: []) {
                        Marker(trip.country, coordinate: markerPosition)
                    }
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Text("Gallery")
                        .font(.title2.bold())
                        .padding(.top, 4)
                    
//                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(trip.images, id: \.self) { image in
                            if let uiImage = UIImage(data: image) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    .frame(height: 120)
                            }
                        }
//                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
        }
//        .ignoresSafeArea()
    }
    
    init(trip: Trip) {
        self.trip = trip
        self.position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trip.latitude, longitude: trip.longitude), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)))
        self.markerPosition = CLLocationCoordinate2D(latitude: trip.latitude, longitude: trip.longitude)
    }
}

#Preview {
    NavigationStack{
        TripDescriptionView(trip: Trip(name: "Trip to Rome", country: "Italy", flag: "🇮🇹", text: "My favorite trip so far!My favorite trip so far!My favorite trip so far!My favorite trip so far!My favorite trip so far!My favorite trip so far!", startDate: .now, endDate: .now.addingTimeInterval(60 * 60 * 24 * 7), images: []))
    }
}
