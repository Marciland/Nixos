#!/usr/bin/env bash

set -euo pipefail

TARGET="1.91.0"

echo "Setting Rust toolchain to: $TARGET"
rustup default "$TARGET"

echo "Adding Rust components for: $TARGET"
rustup component add llvm-tools-preview --toolchain "$TARGET"
rustup target add wasm32-unknown-unknown

CURRENT="$(rustup show active-toolchain | cut -d' ' -f1)"

rustup toolchain list | cut -d' ' -f1 | while read -r toolchain; do
  if [[ "$toolchain" != "$CURRENT" ]]; then
    echo "Uninstalling Rust toolchain: $toolchain"
    rustup toolchain uninstall "$toolchain"
  fi
done