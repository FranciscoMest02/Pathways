//
//  TripDescriptionView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 05/12/24.
//

import SwiftUI

struct TripDescriptionView: View {
    var trip: Trip
    var body: some View {
        ScrollView() {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Image("TripImage")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                    
                    LinearGradient(colors: [.black, .black.opacity(0), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                    
                    VStack {
                        Text(trip.name)
                            .foregroundStyle(.white)
                            .font(.largeTitle.bold())
                        
                        Text("\(trip.formattedStartDate) - \(trip.formattedStartDate)")
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 30)
                    
                }
                    
                    
                Text(trip.text)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack{
        TripDescriptionView(trip: Trip(name: "Trip to Rome", country: "Italy", text: "My favorite trip so far!", startDate: .now, endDate: .now.addingTimeInterval(60 * 60 * 24 * 7)))
    }
}
