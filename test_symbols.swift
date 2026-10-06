import AppKit

let names = ["infinity", "waveform", "waveform.path.ecg", "timelapse", "activity"]
for name in names {
    let img = NSImage(systemSymbolName: name, accessibilityDescription: nil)
    print("\(name): \(img != nil)")
}
