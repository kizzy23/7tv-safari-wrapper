#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXTENSION_ID="${EXTENSION_ID:-lppmekppnliemjclknbagdhoocikieoi}"
DEST_DIR="${DEST_DIR:-$ROOT_DIR/build/chrome-webstore/$EXTENSION_ID}"
CHROME_VERSION="${CHROME_VERSION:-125.0.0.0}"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to download the Chrome Web Store package." >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "node is required to unpack the Chrome Web Store package." >&2
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  echo "unzip is required to extract the Chrome Web Store package." >&2
  exit 1
fi

CRX_PATH="$TMP_DIR/extension.crx"
ZIP_PATH="$TMP_DIR/extension.zip"

curl -fsSL -A "Mozilla/5.0" \
  -o "$CRX_PATH" \
  "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=$CHROME_VERSION&acceptformat=crx3&x=id%3D$EXTENSION_ID%26installsource%3Dondemand%26uc"

node - "$CRX_PATH" "$ZIP_PATH" <<'NODE'
const fs = require("fs");
const [src, dst] = process.argv.slice(2);
const data = fs.readFileSync(src);

if (data.subarray(0, 4).toString("ascii") !== "Cr24") {
  throw new Error("Downloaded file is not a CRX package");
}

const version = data.readUInt32LE(4);
let offset;

if (version === 3) {
  offset = 12 + data.readUInt32LE(8);
} else if (version === 2) {
  offset = 16 + data.readUInt32LE(8) + data.readUInt32LE(12);
} else {
  throw new Error(`Unsupported CRX version ${version}`);
}

fs.writeFileSync(dst, data.subarray(offset));
NODE

rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"
unzip -q "$ZIP_PATH" -d "$DEST_DIR"
rm -rf "$DEST_DIR/_metadata"

node - "$DEST_DIR/manifest.json" <<'NODE'
const fs = require("fs");
const manifestPath = process.argv[2];
const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));

delete manifest.key;
delete manifest.update_url;
delete manifest.browser_specific_settings;

fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
console.log(`${manifest.name} ${manifest.version}`);
NODE

echo "$DEST_DIR"

