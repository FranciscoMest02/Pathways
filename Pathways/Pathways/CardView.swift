//
//  CardView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 05/12/24.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("TripImage")
                .resizable()
                .scaledToFit()
            
            LinearGradient(colors: [.black.opacity(0.7), .black.opacity(0.1), .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                
            VStack(alignment: .leading, spacing: 0) {
                Text("🇮🇹")
                    .frame(width: 30, height: 30)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Spacer()
                
                Text("My trip to Rome")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                
                HStack {
                    Text("45 photos")
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
        .frame(width: 300, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
    }
}

#Preview {
    CardView()
}
