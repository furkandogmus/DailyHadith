import SwiftUI
import AppKit

struct HadithMenuView: View {
    let store: HadithStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 0) {
            HadithContent(store: store, compact: true)
                .frame(height: 480)
            Divider()
            HStack {
                Button("Pencerede Aç") { openWindow(id: "main-window-large") }
                Spacer()
                Button {
                    store.showFirst()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .help("İlk hadise dön")
                Button("Çık") { NSApplication.shared.terminate(nil) }
            }
            .padding(12)
        }
        .frame(width: 460)
    }
}

struct HadithWindowView: View {
    let store: HadithStore

    var body: some View {
        HadithContent(store: store, compact: false)
            .frame(minWidth: 640, minHeight: 600)
    }
}

private struct HadithContent: View {
    let store: HadithStore
    let compact: Bool

    private let ink = Color(red: 0.07, green: 0.13, blue: 0.20)
    private let teal = Color(red: 0.08, green: 0.45, blue: 0.43)

    var body: some View {
        Group {
            if let hadith = store.selectedHadith {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        header(id: hadith.hadithID)
                        dayNavigation
                        textCard(title: "TÜRKÇE", icon: "text.quote", body: hadith.turkishText)
                        if !hadith.arabicText.isEmpty {
                            arabicCard(hadith.arabicText)
                        }
                        attribution
                    }
                    .padding(24)
                }
            } else {
                VStack(spacing: 14) {
                    ContentUnavailableView("Hadisler açılamadı", systemImage: "book.closed", description: Text(store.errorMessage ?? "Uygulamayı yeniden yükleyin."))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 0.94, green: 0.97, blue: 0.96), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private func header(id: String) -> some View {
        HStack(alignment: .top) {
            HStack(spacing: 11) {
                Text("محمد")
                    .font(.system(size: 21, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 38)
                    .background(teal, in: RoundedRectangle(cornerRadius: 11))
                VStack(alignment: .leading, spacing: 3) {
                    Text("GÜNLÜK HADİS")
                        .font(.caption.weight(.bold))
                        .tracking(0.8)
                        .foregroundStyle(teal)
                    Text("Riyâzü’s-Sâlihîn")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(ink)
                }
            }
            Spacer()
            Text("#\(id)")
                .font(.caption.monospaced())
                .foregroundStyle(teal)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(teal.opacity(0.10), in: Capsule())
        }
    }

    private var dayNavigation: some View {
        HStack(spacing: 10) {
            Button(action: store.showPrevious) {
                Label("Önceki", systemImage: "chevron.left")
            }
            .buttonStyle(.bordered)
            .tint(teal)
            .controlSize(.regular)
            .disabled(!store.canShowPrevious)

            Spacer()

            Text("Hadis \(store.selectedIndex + 1) / \(store.hadiths.count)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(teal)

            Spacer()

            Button(action: store.showNext) {
                Label("Sonraki", systemImage: "chevron.right")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .tint(teal)
            .controlSize(.regular)
            .disabled(!store.canShowNext)
        }
        .font(.subheadline)
    }

    private func textCard(title: String, icon: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.bold))
                .tracking(0.7)
                .foregroundStyle(teal)
            Text(body)
                .font(.system(size: 17, weight: .regular, design: .serif))
                .foregroundStyle(ink)
                .lineSpacing(6)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(teal.opacity(0.12), lineWidth: 1))
        .shadow(color: ink.opacity(0.06), radius: 12, y: 5)
    }

    private func arabicCard(_ body: String) -> some View {
        VStack(alignment: .trailing, spacing: 10) {
            Label("العربية", systemImage: "character.book.closed")
                .font(.caption.weight(.bold))
                .foregroundStyle(teal)
            Text(body)
                .font(.system(size: 21, weight: .regular, design: .serif))
                .foregroundStyle(ink)
                .lineSpacing(8)
                .multilineTextAlignment(.trailing)
                .environment(\.layoutDirection, .rightToLeft)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(18)
        .background(teal.opacity(0.075), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(teal.opacity(0.18), lineWidth: 1))
    }

    private var attribution: some View {
        Link("Kaynak: HadisKitaplari.com · Riyâzü’s-Sâlihîn veri seti", destination: URL(string: "https://github.com/HasanEksi/Riyazus-Salihin-Veritabani-HadisKitaplari.com")!)
            .font(.caption)
            .foregroundStyle(teal)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
