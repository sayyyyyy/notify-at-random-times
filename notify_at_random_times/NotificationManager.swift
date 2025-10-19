
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleNotification(for item: NotificationItem) {
        guard item.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = item.bodyText
        content.sound = .default

        // Schedule for a random time between 9 AM and 10 PM
        var dateComponents = DateComponents()
        let hour = Int.random(in: 9...22)
        let minute = Int.random(in: 0...59)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Use a calendar trigger that repeats daily
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Successfully scheduled notification for \(hour):\(minute)")
            }
        }
    }

    func unscheduleNotification(for item: NotificationItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
        print("Unscheduled notification for item: \(item.title)")
    }
}
