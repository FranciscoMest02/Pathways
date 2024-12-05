//
//  ContentView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 04/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Highlighted trips")
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0..<5) { _ in
                                CardView()
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Trips")
        }
    }
}

#Preview {
    ContentView()
}
