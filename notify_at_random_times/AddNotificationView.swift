
import SwiftUI
import SwiftData

struct AddNotificationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var bodyText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                Section(header: Text("Body")) {
                    TextEditor(text: $bodyText)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Notification")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveItem() {
        let newItem = NotificationItem(title: title, bodyText: bodyText)
        modelContext.insert(newItem)
        NotificationManager.shared.scheduleNotification(for: newItem)
        dismiss()
    }
}

#Preview {
    AddNotificationView()
        .modelContainer(for: NotificationItem.self, inMemory: true)
}
