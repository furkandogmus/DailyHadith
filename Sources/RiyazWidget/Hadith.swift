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
}

enum HTMLText {
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
