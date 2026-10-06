import Foundation
import CoreGraphics

if let event = CGEvent(source: nil) {
    print("Location: \(event.location)")
} else {
    print("CGEvent is nil")
}
