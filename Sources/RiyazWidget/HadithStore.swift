import Foundation
import Observation

@MainActor
@Observable
final class HadithStore {
    private(set) var hadiths: [Hadith] = []
    private(set) var errorMessage: String?
    private(set) var selectedIndex = 0

    init() {
        loadBundledHadiths()
        if hadiths.isEmpty {
            errorMessage = "Paket içindeki hadis verisi okunamadı. Uygulamayı yeniden yükleyin."
        }
    }

    var selectedHadith: Hadith? {
        guard hadiths.indices.contains(selectedIndex) else { return nil }
        return hadiths[selectedIndex]
    }

    var canShowPrevious: Bool { selectedIndex > 0 }
    var canShowNext: Bool { selectedIndex + 1 < hadiths.count }

    func showPrevious() {
        guard canShowPrevious else { return }
        selectedIndex -= 1
    }

    func showNext() {
        guard canShowNext else { return }
        selectedIndex += 1
    }

    func showFirst() { selectedIndex = 0 }

    private func loadBundledHadiths() {
        guard let resourceURL = Bundle.main.url(
            forResource: "riyazus-salihin-hadisleri",
            withExtension: "json"
        ),
        let data = try? Data(contentsOf: resourceURL),
        let decoded = try? JSONDecoder().decode([Hadith].self, from: data) else { return }
        hadiths = decoded.sorted {
            (Int($0.hadithID) ?? .max) < (Int($1.hadithID) ?? .max)
        }
    }
}
