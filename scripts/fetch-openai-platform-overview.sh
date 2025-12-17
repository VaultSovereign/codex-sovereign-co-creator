#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
OUT_DIR="${ROOT_DIR}/docs"
URL="${1:-https://platform.openai.com/docs/overview}"
OUT_FILE="${OUT_DIR}/openai-platform-overview.html"

mkdir -p "${OUT_DIR}"

tmp="$(mktemp)"
cleanup() { rm -f "${tmp}"; }
trap cleanup EXIT

if command -v curl >/dev/null 2>&1; then
  curl -L -sS "${URL}" -o "${tmp}"
else
  echo "error: curl is required to fetch ${URL}" >&2
  exit 127
fi

if grep -qiE 'Just a moment|__cf_chl|turnstile|challenge-platform' "${tmp}"; then
  echo "blocked: ${URL} returned a Cloudflare challenge page." >&2
  echo >&2
  echo "Options:" >&2
  echo "  1) Open ${URL} in a real browser and use “Save Page As…” into:" >&2
  echo "     ${OUT_FILE}" >&2
  echo "  2) Or keep using the offline summary:" >&2
  echo "     ${OUT_DIR}/openai-platform-overview.SUMMARY.md" >&2
  exit 2
fi

mv "${tmp}" "${OUT_FILE}"
echo "saved: ${OUT_FILE}"

