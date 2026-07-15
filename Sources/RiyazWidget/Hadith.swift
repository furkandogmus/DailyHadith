import Foundation

struct Hadith: Codable, Identifiable, Hashable {
    let turkish: String
    let arabic: String
    let hadithID: String

    enum CodingKeys: String, CodingKey {
        case turkish, arabic
        case hadithID = "hadith_id"
    }

    var id: String { hadithID }
    var turkishText: String { HTMLText.plainText(from: turkish) }
    var arabicText: String { HTMLText.plainText(from: arabic) }
    var turkishParts: HadithTextParts { HadithTextParts(html: turkish) }
}

struct HadithTextParts {
    let paragraphs: [String]
    let references: String?

    init(html: String) {
        var extracted = HTMLText.paragraphs(from: html)
        if let last = extracted.last, Self.isReference(last) {
            references = last
            extracted.removeLast()
        } else {
            references = nil
        }
        paragraphs = extracted
    }

    private static func isReference(_ text: String) -> Bool {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "(—-– "))
        let sourceNames = [
            "Buhârî", "Buhari", "Müslim", "Tirmizî", "Tirmizi", "Ebû Dâvûd",
            "Ebu Dâvûd", "Nesâî", "Nesai", "İbni Mâce", "İbn Mâce", "Ahmed",
            "Dârimî", "Darimi", "Muvatta", "Hâkim", "Beyhakî", "Taberânî"
        ]
        return sourceNames.contains {
            cleaned.range(of: $0, options: [.caseInsensitive, .diacriticInsensitive])?.lowerBound == cleaned.startIndex
        }
    }

    func displayText(for paragraph: String) -> String {
        guard let colon = paragraph.firstIndex(of: ":") else { return paragraph }
        let before = paragraph[..<colon]
        let after = paragraph[paragraph.index(after: colon)...].trimmingCharacters(in: .whitespacesAndNewlines)
        guard !after.isEmpty else { return paragraph }
        return "\(before):\n\(after)"
    }
}

enum HTMLText {
    static func paragraphs(from html: String) -> [String] {
        plainText(from: html)
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    static func plainText(from html: String) -> String {
        let breaks = html
            .replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive)
            .replacingOccurrences(of: "</p>", with: "\n\n", options: .caseInsensitive)
        guard let data = breaks.data(using: .utf8),
              let attributed = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
              ) else {
            return html.replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
        }
        return attributed.string
            .replacingOccurrences(of: "\\r", with: "")
            .replacingOccurrences(of: #"\n[ \t]*\n[ \t\n]*"#, with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
