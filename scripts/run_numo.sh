#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASE_DIR="${1:-$ROOT/numo-case}"
OUT_DIR="${2:-$ROOT/numo-output}"
PRJ="$CASE_DIR/shotcrete4_linear_closed_fixed_primary_D1e-12.prj"
OGS="$ROOT/bin/ogs"

[[ -x "$OGS" ]] || { echo "ERROR: run ./scripts/install_ogs_numo.sh first" >&2; exit 2; }
[[ -f "$PRJ" ]] || {
  echo "ERROR: NUMO project not found: $PRJ" >&2
  echo "Copy the original NUMO input set into $CASE_DIR without changing the model contents." >&2
  exit 3
}

mkdir -p "$OUT_DIR"
"$OGS" "$PRJ" -o "$OUT_DIR" 2>&1 | tee "$OUT_DIR/ogs.log"
