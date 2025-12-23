FROM texlive/texlive:TL2024-historic

# tlmgr fetches from HTTPS repositories.
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install only what's needed for this CV (XeLaTeX + fonts + latexmk).
RUN tlmgr option repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2024/tlnet-final \
  && tlmgr install \
    latexmk \
    collection-xetex \
    collection-latexextra \
    collection-fontsrecommended \
    collection-fontsextra \
    noto \
    fontawesome \
  && tlmgr path add

WORKDIR /work

# Match GitHub CI (latexmk + xelatex).
ENTRYPOINT ["latexmk", "-pdf", "-xelatex", "-interaction=nonstopmode", "-file-line-error", "-halt-on-error"]
