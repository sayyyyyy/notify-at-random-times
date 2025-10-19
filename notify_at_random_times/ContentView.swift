
//
//  ContentView.swift
//  notify_at_random_times
//
//  Created by 青木聖弥 on 2025/10/19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [NotificationItem]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: NotificationDetailView(item: item)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.bodyText)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { item.isEnabled },
                                set: { newValue in
                                    item.isEnabled = newValue
                                    // No need to explicitly save with SwiftData, changes are auto-saved.
                                    if newValue {
                                        NotificationManager.shared.scheduleNotification(for: item)
                                    } else {
                                        NotificationManager.shared.unscheduleNotification(for: item)
                                    }
                                }
                            )) {
                                Text("Enabled")
                            }
                            .labelsHidden()
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: AddNotificationView()) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = items[index]
                NotificationManager.shared.unscheduleNotification(for: item)
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: NotificationItem.self, inMemory: true)
}

