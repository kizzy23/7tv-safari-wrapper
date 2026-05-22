#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="${UPSTREAM_DIR:-$ROOT_DIR/upstream/Extension}"
DIST_DIR="${DIST_DIR:-$UPSTREAM_DIR/dist}"
SAFARI_DIR="${SAFARI_DIR:-$ROOT_DIR/safari}"
APP_NAME="${APP_NAME:-SevenTV Safari}"
BUNDLE_IDENTIFIER="${BUNDLE_IDENTIFIER:-dev.local.seventv.safari}"

if [[ ! -f "$DIST_DIR/manifest.json" ]]; then
  "$ROOT_DIR/scripts/build-webextension.sh" >/dev/null
fi

if ! xcrun --find safari-web-extension-converter >/dev/null 2>&1; then
  cat >&2 <<'EOF'
safari-web-extension-converter was not found.

Install full Xcode, then select it with:
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

After that, rerun:
  npm run convert:safari
EOF
  exit 1
fi

mkdir -p "$SAFARI_DIR"

xcrun safari-web-extension-converter "$DIST_DIR" \
  --project-location "$SAFARI_DIR" \
  --app-name "$APP_NAME" \
  --bundle-identifier "$BUNDLE_IDENTIFIER" \
  --macos-only \
  --copy-resources \
  --no-open \
  --no-prompt \
  --force

find "$SAFARI_DIR" -maxdepth 2 -name "*.xcodeproj" -print

PROJECT_FILE="$(find "$SAFARI_DIR" -maxdepth 3 -name project.pbxproj -print -quit)"
if [[ -n "$PROJECT_FILE" ]]; then
  /usr/bin/perl -0pi -e 's/PRODUCT_BUNDLE_IDENTIFIER = ([A-Za-z0-9.-]+)\.safari\.Extension;/PRODUCT_BUNDLE_IDENTIFIER = "$1.SevenTV-Safari.Extension";/g' "$PROJECT_FILE"
fi
