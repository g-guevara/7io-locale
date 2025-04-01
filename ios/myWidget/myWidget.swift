
import WidgetKit
import SwiftUI

// Modelo para los textos guardados
struct SavedText: Identifiable, Codable {
    let id: String
    let text: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), savedTexts: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let savedTexts = fetchSavedTexts()
        let entry = SimpleEntry(date: Date(), savedTexts: savedTexts)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let savedTexts = fetchSavedTexts()
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, savedTexts: savedTexts)
        entries.append(entry)

        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    // Función para obtener los textos guardados del storage compartido
    private func fetchSavedTexts() -> [SavedText] {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.7io-locale.shared"),
              let savedTextsString = sharedDefaults.string(forKey: "savedTexts"),
              let data = savedTextsString.data(using: .utf8) else {
            return []
        }
        
        do {
            let decodedTexts = try JSONDecoder().decode([SavedText].self, from: data)
            return decodedTexts
        } catch {
            print("Error decoding saved texts: \(error)")
            return []
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let savedTexts: [SavedText]
}

struct myWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Eventos de hoy:")
                .font(.headline)
                .padding(.bottom, 4)
            
            if entry.savedTexts.isEmpty {
                Text("No hay eventos guardados")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                // Mostrar solo los eventos, bien simple como pediste
                ForEach(entry.savedTexts) { text in
                    Text(text.text)
                        .font(.caption)
                        .lineLimit(1)
                        .padding(.vertical, 2)
                }
            }
        }
        .padding()
    }
}

@main
struct myWidget: Widget {
    let kind: String = "myWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            myWidgetEntryView(entry: entry)
                .padding()
                .background(Color(UIColor.systemBackground))
        }
        .configurationDisplayName("Mis Eventos")
        .description("Muestra tus eventos para hoy")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
