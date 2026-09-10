#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/ogs-src"
BUILD="$ROOT/ogs-build"
OGS_REPO="https://github.com/kuateric/ogs.git"
OGS_COMMIT="5e0c4c0971996d36112e30508074d8f56fb2a60d"

if [[ ! -d "$SRC/.git" ]]; then
  git clone --filter=blob:none "$OGS_REPO" "$SRC"
fi

git -C "$SRC" fetch origin "$OGS_COMMIT"
git -C "$SRC" checkout --detach "$OGS_COMMIT"

actual="$(git -C "$SRC" rev-parse HEAD)"
[[ "$actual" == "$OGS_COMMIT" ]] || { echo "ERROR: wrong OGS commit: $actual" >&2; exit 2; }

grep -q "NUMO: positivity-preserving row-sum lumping of the reaction projection" \
  "$SRC/ProcessLib/ComponentTransport/ComponentTransportFEM.h" || {
    echo "ERROR: NUMO reaction-projection correction not present" >&2
    exit 3
  }

cmake -S "$SRC" -B "$BUILD" \
  -DCMAKE_BUILD_TYPE=Release \
  -DOGS_BUILD_GUI=OFF \
  -DOGS_BUILD_PROCESSES=ComponentTransport \
  -DOGS_BUILD_TESTING=OFF \
  -DOGS_BUILD_UTILS=OFF

cmake --build "$BUILD" --parallel 2 --target ogs

OGS_BIN="$(find "$BUILD" -type f -name ogs -perm -111 | head -n1)"
[[ -n "$OGS_BIN" ]] || { echo "ERROR: built OGS executable not found" >&2; exit 4; }
mkdir -p "$ROOT/bin"
ln -sfn "$OGS_BIN" "$ROOT/bin/ogs"

echo "Installed corrected OGS NUMO build"
echo "Commit: $actual"
echo "Binary: $ROOT/bin/ogs"
