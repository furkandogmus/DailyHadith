# Günlük Hadis

Riyâzü's-Sâlihîn'den Türkçe ve Arapça hadisleri sade bir macOS penceresinde okumak için küçük, yerel bir uygulama.

## Neler var?

- 1.900 hadis: Türkçe metin, Arapça metin ve kaynak bilgileri
- Uygulama her açıldığında 1. hadisten başlar
- Önceki, sonraki ve rastgele hadis düğmeleri
- İsteğe bağlı **Girişte Aç** ayarı
- Tüm veri uygulama paketinin içindedir: internet bağlantısı gerekmez
- Uygulama Documents, Desktop veya Downloads klasörlerine erişmez; hiçbir kişisel veri toplamaz ya da göndermez

## İndir ve kur

En güncel dosyaları [GitHub Releases](https://github.com/furkandogmus/DailyHadith/releases) sayfasından indirin. Bu sürüm Apple Silicon Mac'ler (M1, M2, M3, M4 ve sonrası) içindir.

### Kolay yol: ZIP

1. `DailyHadith-…-macos-arm64.zip` dosyasını indirin ve çift tıklayıp açın.
2. `DailyHadith.app` dosyasını çalıştırın veya kendi kullanıcı klasörünüzdeki `Applications` klasörüne taşıyın (`~/Applications`). Bu yöntem yönetici parolası istemez.

### .pkg ile kurulum

`DailyHadith-…-macos-arm64.pkg` dosyasını açın ve kurulum adımlarını takip edin. Uygulama `/Applications` klasörüne kurulur. Bu sistem klasörü olduğu için macOS yönetici parolası sorabilir.

## “Open Anyway / Yine de Aç” uyarısı

Uygulama şu an Apple Developer ID ile imzalanmış ve notarize edilmiş değildir. Bu yüzden macOS, ilk açılışta geliştiriciyi doğrulayamadığını söyleyip uygulamayı engelleyebilir. Bu, uygulamanın Documents izni istemesiyle ilgili değildir; macOS Gatekeeper güvenlik kontrolüdür.

Yalnızca uygulamayı bu GitHub deposundan ya da Releases sayfasından indirdiğinizi doğruladıktan sonra:

1. `DailyHadith.app` dosyasını bir kez açmayı deneyin ve uyarıyı kapatın.
2. **Sistem Ayarları → Gizlilik ve Güvenlik** bölümünü açın.
3. Sayfayı **Güvenlik** bölümüne kadar kaydırın ve Günlük Hadis'in yanında görünen **Yine de Aç / Open Anyway** düğmesine basın.
4. Gelen son uyarıda **Aç** seçeneğini onaylayın. macOS parolanızı isteyebilir.

Bu işlem yalnızca bu uygulama için istisna oluşturur. Apple'ın güncel yönergeleri için: [Güvenli şekilde açamadığınız uygulamalar](https://support.apple.com/en-us/102445).

## Gizlilik ve güvenlik

- Hadis verisi uygulamanın içindeki JSON dosyasından okunur.
- Uygulama ağ bağlantısı kurmaz; çevrimdışı çalışır.
- Kişisel klasörlere erişim, dosya seçici, telemetri veya hesap girişi yoktur.
- Her değişiklik GitHub Actions ile derlenir; veri bütünlüğü ve yasaklı erişim API'leri kontrol edilir. CodeQL güvenlik analizi de çalışır.

Kaynak kodu inceleyebilir veya kendi bilgisayarınızda derleyebilirsiniz. İmzasız bir uygulamada Gatekeeper istisnası vermeden önce indirme kaynağını kontrol etmeniz önerilir.

## Kullanım

- Sol ve sağ oklarla hadisler arasında ilerleyin.
- Ortadaki karıştır simgesi rastgele bir hadis getirir.
- Uygulama menüsündeki **Girişte Aç** seçeneği uygulamayı macOS oturumunuz açıldığında başlatır.

## Geliştirme

macOS 14+ ve Xcode Command Line Tools yeterlidir.

```bash
swift run DailyHadith
```

Dağıtım dosyaları oluşturmak için:

```bash
./scripts/make-app.sh
./scripts/make-release.sh  # ZIP
./scripts/make-pkg.sh      # .pkg
```

## Veri kaynağı

Hadis veri seti, [HasanEksi/Riyazus-Salihin-Veritabani-HadisKitaplari.com](https://github.com/HasanEksi/Riyazus-Salihin-Veritabani-HadisKitaplari.com) deposundan paketlenmiştir. Veri setinin lisans ve kullanım şartlarını kaynak depodan ayrıca inceleyin.
