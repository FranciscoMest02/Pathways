//
//  PathwaysApp.swift
//  Pathways
//
//  Created by Francisco Mestizo on 04/12/24.
//

import SwiftUI
import SwiftData

@main
struct PathwaysApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Trip.self)
    }
}
