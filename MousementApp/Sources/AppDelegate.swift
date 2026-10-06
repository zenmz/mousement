import Cocoa
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    private var cancellables = Set<AnyCancellable>()
    
    // Interval options
    let intervals: [Double] = [1, 3, 5, 10, 15]
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        checkAccessibilityPermissions()
        HotKeyManager.shared.register()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        setupMenu()
        
        // Listen to active state to change icon color
        Simulator.shared.$isActive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] active in
                self?.updateIcon(active: active)
                self?.updateMenuState()
            }
            .store(in: &cancellables)
            
        updateIcon(active: Simulator.shared.isActive)
        updateMenuState()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        HotKeyManager.shared.unregister()
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        // 1. Toggle Button
        let toggleItem = NSMenuItem(title: "Start Simulation", action: #selector(toggleSimulation), keyEquivalent: "s")
        toggleItem.keyEquivalentModifierMask = [.command, .shift]
        toggleItem.tag = 999 // Special tag to find it later
        menu.addItem(toggleItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // 2. Interval Header (Disabled)
        let headerItem = NSMenuItem(title: "Interval (Jeda Waktu):", action: nil, keyEquivalent: "")
        headerItem.isEnabled = false
        menu.addItem(headerItem)
        
        // 3. Interval Options
        for interval in intervals {
            let item = NSMenuItem(title: "\(Int(interval)) Menit", action: #selector(setInterval(_:)), keyEquivalent: "")
            item.representedObject = interval
            menu.addItem(item)
        }
        
        menu.addItem(NSMenuItem.separator())
        
        // 4. Quit
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func toggleSimulation() {
        Simulator.shared.toggle()
    }
    
    @objc func setInterval(_ sender: NSMenuItem) {
        if let interval = sender.representedObject as? Double {
            Simulator.shared.intervalMinutes = interval
            Simulator.shared.updateTimerIfActive() // Restart timer with new interval if active
            updateMenuState()
        }
    }
    
    private func updateMenuState() {
        guard let menu = statusItem.menu else { return }
        
        // Update Toggle Text
        if let toggleItem = menu.item(withTag: 999) {
            toggleItem.title = Simulator.shared.isActive ? "Stop Simulation" : "Start Simulation"
        }
        
        // Update Checkmarks for Intervals
        let currentInterval = Simulator.shared.intervalMinutes
        for item in menu.items {
            if let itemInterval = item.representedObject as? Double {
                item.state = (itemInterval == currentInterval) ? .on : .off
            }
        }
    }
    
    private func updateIcon(active: Bool) {
        guard let button = statusItem.button else { return }
        
        let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        guard let baseImage = NSImage(systemSymbolName: "cursorarrow.motionlines", accessibilityDescription: "Mousement")?.withSymbolConfiguration(config) else { return }
        guard let image = baseImage.copy() as? NSImage else { return }
        
        if active {
            image.isTemplate = true
        } else {
            image.isTemplate = false
            image.lockFocus()
            NSColor.systemGray.set()
            let rect = NSRect(origin: .zero, size: image.size)
            rect.fill(using: .sourceAtop)
            image.unlockFocus()
        }
        
        button.image = image
    }
    
    private func checkAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !accessEnabled {
            let alert = NSAlert()
            alert.messageText = "Accessibility Permissions Required"
            alert.informativeText = "Mousement needs Accessibility permissions to simulate mouse movements. Please enable it in System Settings > Privacy & Security > Accessibility, then restart the app."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Open System Settings")
            alert.addButton(withTitle: "Quit")
            
            if alert.runModal() == .alertFirstButtonReturn {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
            }
            NSApp.terminate(nil)
        }
    }
}
