import AppKit

let destination = URL(fileURLWithPath: CommandLine.arguments.dropFirst().first ?? "AppIcon.iconset")
let renditions: [(name: String, size: Int)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]
try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)

func icon(size: Int) -> Data? {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let background = NSGradient(colors: [NSColor(calibratedRed: 0.05, green: 0.27, blue: 0.27, alpha: 1), NSColor(calibratedRed: 0.08, green: 0.49, blue: 0.45, alpha: 1)])!
    background.draw(in: rect, angle: -45)
    let inset = CGFloat(size) * 0.09
    NSColor.white.withAlphaComponent(0.12).setFill()
    NSBezierPath(roundedRect: rect.insetBy(dx: inset, dy: inset), xRadius: CGFloat(size) * 0.18, yRadius: CGFloat(size) * 0.18).fill()
    let text = "محمد" as NSString
    let font = NSFont(name: "Geeza Pro", size: CGFloat(size) * 0.34) ?? .systemFont(ofSize: CGFloat(size) * 0.34, weight: .bold)
    let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: NSColor.white]
    let textSize = text.size(withAttributes: attributes)
    text.draw(at: NSPoint(x: (CGFloat(size) - textSize.width) / 2, y: (CGFloat(size) - textSize.height) / 2 + CGFloat(size) * 0.035), withAttributes: attributes)
    image.unlockFocus()
    guard let tiff = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
    return bitmap.representation(using: .png, properties: [:])
}

for rendition in renditions {
    guard let data = icon(size: rendition.size) else { continue }
    try data.write(to: destination.appendingPathComponent(rendition.name))
}
