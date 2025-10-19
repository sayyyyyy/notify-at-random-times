
import SwiftUI
import SwiftData

struct NotificationDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: NotificationItem
    
    @State private var showingDeleteConfirm = false

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Title", text: $item.title)
                TextEditor(text: $item.bodyText)
                    .frame(minHeight: 150)
            }
            
            Section(header: Text("Actions")) {
                Toggle(isOn: $item.isEnabled) {
                    Text("Enable Notification")
                }
                
                Button("Delete Notification", role: .destructive) {
                    showingDeleteConfirm = true
                }
            }
        }
        .navigationTitle("Edit Notification")
        .onDisappear(perform: updateItem)
        .alert("Delete Notification?", isPresented: $showingDeleteConfirm) {
            Button("Delete", role: .destructive) { deleteItem() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private func updateItem() {
        // SwiftData auto-saves, so we just need to handle the notification scheduling
        if item.isEnabled {
            NotificationManager.shared.scheduleNotification(for: item)
        } else {
            NotificationManager.shared.unscheduleNotification(for: item)
        }
    }
    
    private func deleteItem() {
        NotificationManager.shared.unscheduleNotification(for: item)
        modelContext.delete(item)
        dismiss()
    }
}
