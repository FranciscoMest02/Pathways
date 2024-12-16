//
//  CardView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 05/12/24.
//

import SwiftUI

struct CardView: View {
    var trip: Trip
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if trip.images.first != nil {
                if let uiImage = UIImage(data: trip.images.first!) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 500)
                }
            } else {
                Image("TripImage")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 500)
            }
            
            LinearGradient(colors: [.black.opacity(0.7), .black.opacity(0.1), .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                
            VStack(alignment: .leading, spacing: 0) {
                Text(trip.flag)
                    .frame(width: 30, height: 30)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Spacer()
                
                Text(trip.name)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("\(trip.imageCount) photos")
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.white)
                        .clipShape(.capsule)
                    
                    Text("2 accompanions")
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.white)
                        .clipShape(.capsule)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            
        }
        .frame(height: 500)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
    }
}

#Preview {
    let trip1 = Trip(name: "First Time in Rome", country: "Italy", flag: "🇮🇹", text: "Description here...", startDate: .now, endDate: .now, images: [])

    CardView(trip: trip1)
}
