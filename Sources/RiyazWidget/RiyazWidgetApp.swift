import SwiftUI

@main
@MainActor
struct RiyazWidgetApp: App {
    @State private var store = HadithStore()

    var body: some Scene {
        WindowGroup("Günlük Hadis", id: "main-window-large") {
            HadithWindowView(store: store)
        }
        .defaultSize(width: 800, height: 760)

        MenuBarExtra {
            HadithMenuView(store: store)
        } label: {
            Label("Günlük Hadis", systemImage: "quote.bubble")
        }
        .menuBarExtraStyle(.window)
    }
}
