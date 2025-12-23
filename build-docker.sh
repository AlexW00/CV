#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-cv-latex:local}"
PLATFORM="${PLATFORM:-linux/amd64}"
ROOT_TEX="${1:-alexander-weichart-cv.tex}"

docker build --platform "$PLATFORM" -t "$IMAGE_NAME" .

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
