#! /bin/sh
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi
xelatex alexander-weichart-cv.tex
xelatex alexander-weichart-cv-ja.tex