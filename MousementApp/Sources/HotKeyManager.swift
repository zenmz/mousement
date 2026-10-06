import Cocoa
import SwiftUI

class HotKeyManager: ObservableObject {
    static let shared = HotKeyManager()
    private var globalMonitor: Any?

    func register() {
        // Cmd + Option + Control + M
        // Keycode for 'M' is 46
        let options: NSEvent.ModifierFlags = [.command, .option, .control]
        let mKeyCode: UInt16 = 46

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            if event.keyCode == mKeyCode && flags == options {
                DispatchQueue.main.async {
                    Simulator.shared.toggle()
                }
            }
        }
        
        // Also add a local monitor in case the app is currently active
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            if event.keyCode == mKeyCode && flags == options {
                DispatchQueue.main.async {
                    Simulator.shared.toggle()
                }
                return nil
            }
            return event
        }
    }

    func unregister() {
        if let monitor = globalMonitor {
            NSEvent.removeMonitor(monitor)
            globalMonitor = nil
        }
    }
}
