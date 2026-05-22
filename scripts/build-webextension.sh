#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="${UPSTREAM_DIR:-$ROOT_DIR/upstream/Extension}"
YARN_VERSION="${YARN_VERSION:-1.22.22}"
BUILD_MODE="${BUILD_MODE:-prod}"
NODE_OPTIONS="${NODE_OPTIONS:---max-old-space-size=4096}"
export NODE_OPTIONS

if [[ ! -d "$UPSTREAM_DIR/.git" ]]; then
  "$ROOT_DIR/scripts/sync-upstream.sh"
fi

if ! command -v node >/dev/null 2>&1; then
  echo "node is required. Install Node.js before building 7TV." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required so this wrapper can run Yarn $YARN_VERSION without a global install." >&2
  exit 1
fi

cd "$UPSTREAM_DIR"
npm exec --yes --package "yarn@$YARN_VERSION" -- yarn install --frozen-lockfile
npm exec --yes --package "yarn@$YARN_VERSION" -- yarn "build:$BUILD_MODE"

if [[ ! -f "$UPSTREAM_DIR/dist/manifest.json" ]]; then
  echo "Build finished, but dist/manifest.json was not created." >&2
  exit 1
fi

echo "$UPSTREAM_DIR/dist"

