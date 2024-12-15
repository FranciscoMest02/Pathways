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
    @Query var trips: [Trip]
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), name: "This is placeholder")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), name: "This is snapshot")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 6 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, name: "Test")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
}

struct PathwaysWidgetEntryView : View {
    var entry: Provider.Entry
    @Query var trips: [Trip]
    
    let targetSize = CGSize(width: 600, height: 600)
    
    var body: some View {
        VStack {
            if trips.first?.imageCount ?? 0 > 0 {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Vacations in")
                            .font(.caption)
                        Text(trips.first?.name ?? "Default")
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
            if trips.first?.imageCount ?? 0 > 0 {
                if let uiImage = UIImage(data: trips.first!.images.first!) {
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

struct PathwaysWidget: Widget {
    let kind: String = "PathwaysWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PathwaysWidgetEntryView(entry: entry)
                //                    .containerBackground(.fill.tertiary, for: .widget)
                    .modelContainer(for: [Trip.self])
            } else {
                PathwaysWidgetEntryView(entry: entry)
                    .modelContainer(for: [Trip.self])
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
    SimpleEntry(date: .now, name: "Entry 1")
    SimpleEntry(date: .now, name: "Entry 2")
}
