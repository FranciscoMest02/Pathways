//
//  PathwaysWidget.swift
//  PathwaysWidget
//
//  Created by Francisco Mestizo on 12/12/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import UIKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), name: "Italy", image: Data(), isPlaceholder: true)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), name: "Italy", image: Data(), isPlaceholder: true)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        let fetchDescriptor = FetchDescriptor<Trip>()
        
        if let trips = try? modelContext.fetch(fetchDescriptor) {
            guard let randomTrip = trips.randomElement() else {
                return
            }
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            let size = randomTrip.imageCount
            for hourOffset in 0 ..< 6 {
                let randomIndex = Int.random(in: 0..<size)
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, name: randomTrip.country, image: randomTrip.images[randomIndex])
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let image: Data
    var isPlaceholder = false
}

struct PathwaysWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            if entry.name.count > 0 {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Vacations in")
                            .font(.caption)
                        Text(entry.name)
                            .font(.title.bold())
                    }
                    .foregroundStyle(.white)
                    Spacer()
                }
            } else {
                Text("Create a trip to show the photos here")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
        }
        .containerBackground(for: .widget) {
            if(entry.isPlaceholder) {
                Image(.smallTrip)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 360)
                    .clipped()
            } else {
                if entry.name.count > 0 {
                    if let uiImage = UIImage(data: entry.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 360)
                            .clipped()
                    }
                }  else {
                    Color.black
                }
            }
        }
    }
}

struct PathwaysWidget: Widget {
    let kind: String = "PathwaysWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PathwaysWidgetEntryView(entry: entry)
            } else {
                PathwaysWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Pathway widgets")
        .description("Re-live your trips. See where you've been and where you're going")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    PathwaysWidget()
} timeline: {
    SimpleEntry(date: .now, name: "Entry 1", image: Data())
    SimpleEntry(date: .now, name: "Entry 2", image: Data())
}
