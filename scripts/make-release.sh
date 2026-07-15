#!/bin/zsh
set -euo pipefail

root="${0:A:h:h}"
version="1.0.3"
archive="$root/dist/DailyHadith-${version}-macos-arm64.zip"

"$root/scripts/make-app.sh"
mkdir -p "$root/dist"
rm -f "$archive" "$archive.sha256"
ditto -c -k --sequesterRsrc --keepParent "$root/build/DailyHadith.app" "$archive"
shasum -a 256 "$archive" > "$archive.sha256"

echo "GitHub Release dosyası: $archive"
