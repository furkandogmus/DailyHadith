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
# SwiftPM resolves Bundle.module relative to the .app bundle itself.
# This prevents a fallback to the development path under Documents.
cp -R "$root/.build/release/"*.bundle "$app/"

echo "Hazır: $app"
