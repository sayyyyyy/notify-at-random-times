import SwiftUI
import SwiftData

@main
struct notify_at_random_timesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: NotificationItem.self)
    }
}
