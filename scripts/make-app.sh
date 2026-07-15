#!/bin/zsh
set -euo pipefail

root="${0:A:h:h}"
cd "$root"

swift build -c release

app="$root/build/DailyHadith.app"
iconset="$root/.build/AppIcon.iconset"
icon="$root/.build/AppIcon.icns"
swift "$root/scripts/create-icon.swift" "$iconset"
xcrun iconutil -c icns "$iconset" -o "$icon"
rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
cp "$root/.build/release/DailyHadith" "$app/Contents/MacOS/DailyHadith"
cp "$root/AppBundle/Info.plist" "$app/Contents/Info.plist"
cp "$icon" "$app/Contents/Resources/AppIcon.icns"
# The hadith corpus lives in the app's standard resource directory. Runtime
# reads only Bundle.main; it never falls back to a development/Documents path.
cp "$root/Sources/RiyazWidget/Resources/riyazus-salihin-hadisleri.json" "$app/Contents/Resources/"

echo "Hazır: $app"
