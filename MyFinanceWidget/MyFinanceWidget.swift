//
//  MyFinanceWidget.swift
//  MyFinanceWidget
//
//  Created by Вова Сербин on 01.07.2021.
//

import WidgetKit
import SwiftUI
import Intents

class ContentViewDelegate: ObservableObject {
   @Published var categoryName: String = ""
}

struct Provider: IntentTimelineProvider {
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        let entry = SimpleEntry(date: Date())
        entries.append(entry)
        
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.init(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry.init(date: Date())
        completion(entry)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let category = ["Category1", "Category2", "Category3"]
}

struct MyFinanceWidgetEntryView : View {
    var entry: Provider.Entry
    
    @ObservedObject var delegate: ContentViewDelegate

    var body: some View {
        VStack {
            Text(entry.category[0])
        }
    }
}

@main
struct MyFinanceWidget: Widget {
    let kind: String = "MyFinanceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyFinanceWidgetEntryView(entry: entry, delegate: ContentViewDelegate())
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyFinanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyFinanceWidgetEntryView(entry: SimpleEntry.init(date: Date()), delegate: ContentViewDelegate())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
