# Günlük Hadis (DailyHadith) — macOS uygulaması

Riyâzü's-Sâlihîn'den hadisleri sırayla gösteren küçük bir macOS uygulaması. 1900 hadislik Türkçe/Arapça veri seti uygulama paketine dahildir; uygulama her zaman 1. hadisten başlar ve internete bağlanmaz.

## Çalıştırma

macOS 14+ ve Xcode / Command Line Tools ile:

```bash
swift run DailyHadith
```

## Uygulama paketi oluşturma

Çift tıklanabilen uygulama paketi oluşturmak için:

```bash
./scripts/make-app.sh
```

Bu komut `build/DailyHadith.app` oluşturur. Finder'da çift tıklayabilir veya Applications klasörüne taşıyabilirsiniz.

## GitHub'da paylaşma

GitHub Releases bölümüne `dist/DailyHadith-1.0.0-macos-arm64.zip` dosyasını yüklemek için:

```bash
./scripts/make-release.sh
```

Bu sürüm Apple Silicon (M1/M2/M3/M4) Mac'ler içindir. İndiren kişi ZIP dosyasını açıp `DailyHadith.app` uygulamasını **Applications** klasörüne sürükler. Uygulama henüz Developer ID ile imzalanıp Apple tarafından notarize edilmediği için ilk açılışta Finder'da uygulamaya Control-tıklayıp **Aç** demesi gerekebilir.

Alternatif olarak `.pkg` yükleyicisi üretmek için:

```bash
./scripts/make-pkg.sh
```

Bu paket uygulamayı otomatik olarak **Applications** klasörüne kurar. İmzasız olduğu için macOS yine güvenlik onayı isteyebilir; bu durumda **Sistem Ayarları > Gizlilik ve Güvenlik > Yine de Aç** seçilir.

Uygulama veriyi yalnızca paket içindeki JSON dosyasından okur; internet bağlantısı hiçbir aşamada gerekmez.

## Kaynak ve atıf

Hadis verisi [HasanEksi/Riyazus-Salihin-Veritabani-HadisKitaplari.com](https://github.com/HasanEksi/Riyazus-Salihin-Veritabani-HadisKitaplari.com) deposundan paketlenmiştir. Uygulama bu kaynağa bağlantı verir; veri setinin kullanım koşullarını dağıtımdan önce kaynak sahibiyle doğrulayın.
