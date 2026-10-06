import Foundation
import CoreGraphics
import ApplicationServices
import SwiftUI

class Simulator: ObservableObject {
    static let shared = Simulator()
    
    @Published var isActive = false
    private var timer: Timer?
    
    // Default 3 minutes (180 seconds)
    @AppStorage("intervalMinutes") var intervalMinutes: Double = 3.0
    
    func toggle() {
        isActive.toggle()
        if isActive {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        let interval = max(1.0, intervalMinutes) * 60.0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.simulateActivity()
        }
        // Optionally run once immediately or wait for the first interval.
        // For natural behavior, maybe just wait for the interval.
        simulateActivity()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimerIfActive() {
        if isActive {
            startTimer()
        }
    }
    
    func simulateActivity() {
        guard let currentLoc = CGEvent(source: nil)?.location else { return }
        
        // Small random offset
        let dx = CGFloat.random(in: -15...15)
        let dy = CGFloat.random(in: -15...15)
        let newLoc = CGPoint(x: currentLoc.x + dx, y: currentLoc.y + dy)
        
        // Move mouse
        if let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: newLoc, mouseButton: .left) {
            moveEvent.post(tap: .cghidEventTap)
        }
        
        // Small scroll
        let scrollY = Int32.random(in: -2...2)
        if scrollY != 0, let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: .line, wheelCount: 1, wheel1: scrollY, wheel2: 0, wheel3: 0) {
            scrollEvent.post(tap: .cghidEventTap)
        }
        
        // Return back after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let returnEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: currentLoc, mouseButton: .left) {
                returnEvent.post(tap: .cghidEventTap)
            }
        }
    }
}
