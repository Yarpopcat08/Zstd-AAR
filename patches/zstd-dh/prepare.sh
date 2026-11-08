#!/bin/bash
# Builds a DH-patched copy of zstd outside the submodule, should ONLY be run in workflows!!!

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC_DIR="$REPO_ROOT/app/src/main/zstd"
DST_DIR="$REPO_ROOT/app/src/main/zstd-dh"

rm -rf "$DST_DIR"
mkdir -p "$DST_DIR/src/main"
cp "$SRC_DIR/CMakeLists.txt" "$SRC_DIR/version" "$DST_DIR/"
cp -a "$SRC_DIR/src/main/native" "$DST_DIR/src/main/native"

sed -i 's/zstd-jni-${NATIVE_VERSION}/zstd-jni_dh-${NATIVE_VERSION}/' "$DST_DIR/CMakeLists.txt"

bash "$REPO_ROOT/patches/zstd-dh/renamer.sh" "$DST_DIR/src/main/native"
