#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="${UPSTREAM_DIR:-$ROOT_DIR/upstream/Extension}"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/SevenTV/Extension.git}"
UPSTREAM_REF="${UPSTREAM_REF:-nightly-release}"

mkdir -p "$(dirname "$UPSTREAM_DIR")"

if [[ ! -d "$UPSTREAM_DIR/.git" ]]; then
  git clone --depth 1 --branch "$UPSTREAM_REF" "$UPSTREAM_URL" "$UPSTREAM_DIR"
else
  git -C "$UPSTREAM_DIR" fetch --depth 1 origin "$UPSTREAM_REF"
  git -C "$UPSTREAM_DIR" checkout --detach "FETCH_HEAD"
fi

git -C "$UPSTREAM_DIR" rev-parse HEAD
