import SwiftUI
import AppKit
import ServiceManagement

@MainActor
struct HadithMenuView: View {
    let store: HadithStore
    @Environment(\.openWindow) private var openWindow
    @State private var launchesAtLogin = false
    @State private var loginItemMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            HadithContent(store: store, compact: true)
                .frame(height: 480)
            Divider()
            Toggle("Girişte Aç", isOn: Binding(
                get: { launchesAtLogin },
                set: { setLaunchAtLogin($0) }
            ))
            .toggleStyle(.switch)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            if let loginItemMessage {
                Text(loginItemMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
            }
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
        .onAppear { refreshLoginItemStatus() }
    }

    private func refreshLoginItemStatus() {
        launchesAtLogin = SMAppService.mainApp.status == .enabled
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            refreshLoginItemStatus()
            loginItemMessage = SMAppService.mainApp.status == .requiresApproval
                ? "macOS onayı için Sistem Ayarları > Giriş Öğeleri bölümünü açın."
                : nil
        } catch {
            refreshLoginItemStatus()
            loginItemMessage = "Girişte açma ayarı değiştirilemedi."
        }
    }
}

@MainActor
struct HadithWindowView: View {
    let store: HadithStore

    var body: some View {
        HadithContent(store: store, compact: false)
            .frame(minWidth: 640, minHeight: 600)
    }
}

@MainActor
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
                        turkishCard(hadith.turkishParts)
                        if !hadith.arabicText.isEmpty {
                            arabicCard(hadith.arabicText)
                        }
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
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.bold))
                    .frame(width: 42, height: 32)
            }
            .buttonStyle(.bordered)
            .tint(teal)
            .controlSize(.regular)
            .disabled(!store.canShowPrevious)
            .accessibilityLabel("Önceki hadis")

            Spacer()

            HStack(spacing: 8) {
                Text("Hadis \(store.selectedIndex + 1) / \(store.hadiths.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(teal)
                Button(action: store.showRandom) {
                    Image(systemName: "shuffle")
                        .font(.body.weight(.bold))
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.bordered)
                .tint(teal)
                .help("Rastgele hadis getir")
                .accessibilityLabel("Rastgele hadis getir")
            }

            Spacer()

            Button(action: store.showNext) {
                Image(systemName: "chevron.right")
                    .font(.title3.weight(.bold))
                    .frame(width: 42, height: 32)
            }
            .buttonStyle(.bordered)
            .tint(teal)
            .controlSize(.regular)
            .disabled(!store.canShowNext)
            .accessibilityLabel("Sonraki hadis")
        }
        .font(.subheadline)
    }

    private func turkishCard(_ parts: HadithTextParts) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("TÜRKÇE", systemImage: "text.quote")
                .font(.caption.weight(.bold))
                .tracking(0.7)
                .foregroundStyle(teal)
            ForEach(Array(parts.paragraphs.enumerated()), id: \.offset) { index, paragraph in
                Text(parts.displayText(for: paragraph))
                    .font(.system(size: 17, weight: index == 0 ? .medium : .regular, design: .serif))
                    .foregroundStyle(ink)
                    .lineSpacing(6)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, index + 1 == parts.paragraphs.count ? 0 : 6)
            }
            if let references = parts.references {
                Divider()
                    .padding(.top, 4)
                Label("KAYNAKLAR", systemImage: "books.vertical")
                    .font(.caption2.weight(.bold))
                    .tracking(0.7)
                    .foregroundStyle(teal)
                Text(references)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .textSelection(.enabled)
            }
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

}
