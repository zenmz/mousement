import SwiftUI

@main
struct MousementApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // App settings window is managed manually by AppDelegate,
        // and menu bar icon is also manual NSStatusItem.
        // We use a dummy Settings scene to satisfy the App protocol.
        Settings {
            EmptyView()
        }
    }
}
