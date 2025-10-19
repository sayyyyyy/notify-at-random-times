
import Foundation
import SwiftData

@Model
final class NotificationItem {
    var id: UUID
    var title: String
    var bodyText: String
    var isEnabled: Bool
    var creationDate: Date

    init(title: String, bodyText: String, isEnabled: Bool = true) {
        self.id = UUID()
        self.title = title
        self.bodyText = bodyText
        self.isEnabled = isEnabled
        self.creationDate = Date()
    }
}
