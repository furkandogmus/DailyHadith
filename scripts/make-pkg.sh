#!/bin/zsh
set -euo pipefail

root="${0:A:h:h}"
version="1.0.5"
output="$root/dist/DailyHadith-${version}-macos-arm64.pkg"
staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT

"$root/scripts/make-app.sh"
mkdir -p "$staging/Applications" "$root/dist"
# pkgbuild temporary paths can mishandle decomposed Turkish characters. The
# bundle's displayed name remains "Günün Hadisi" via its Info.plist.
cp -R "$root/build/DailyHadith.app" "$staging/Applications/DailyHadith.app"

pkgbuild \
  --root "$staging" \
  --identifier "com.furkan.dailyhadith" \
  --version "$version" \
  --component-plist "$root/packaging/component.plist" \
  --install-location / \
  "$output"

shasum -a 256 "$output" > "$output.sha256"
echo "GitHub Release dosyası: $output"
