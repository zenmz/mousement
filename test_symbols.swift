import AppKit

let names = ["cursorarrow.motionlines", "cursorarrow", "cursorarrow.rays", "magicmouse", "mouse.fill", "arrow.up.and.down.and.arrow.left.and.right"]
for name in names {
    let img = NSImage(systemSymbolName: name, accessibilityDescription: nil)
    print("\(name): \(img != nil)")
}
