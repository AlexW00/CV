#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

IMAGE_NAME="${IMAGE_NAME:-cv-latex:local}"
PLATFORM="${PLATFORM:-linux/amd64}"

docker build --platform "$PLATFORM" -t "$IMAGE_NAME" .

# If specific .tex files are given, build only those. Otherwise build both.
if [ $# -gt 0 ]; then
  TEX_FILES=("$@")
else
  TEX_FILES=(alexander-weichart-cv.tex alexander-weichart-cv-ja.tex)
fi

for ROOT_TEX in "${TEX_FILES[@]}"; do
  # Pass PHONE_NUMBER through if set (template.cls reads it via kpsewhich --var-value).
  docker run --rm \
    --platform "$PLATFORM" \
    -u "$(id -u):$(id -g)" \
    -e "HOME=/tmp" \
    -e "PHONE_NUMBER=${PHONE_NUMBER:-}" \
    -v "$PWD:/work" \
    -w /work \
    "$IMAGE_NAME" \
    "$ROOT_TEX"
  echo "Built: ${ROOT_TEX%.tex}.pdf"
done
