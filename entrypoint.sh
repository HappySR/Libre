#!/bin/sh
set -ex

if [ ! -d "/root/.local/share/argos-translate/packages" ]; then
  libretranslate --update-models  # <-- Hyphen here
  libretranslate --install-lang en || true  # <-- Hyphen here
  libretranslate --install-lang hi || true
  libretranslate --install-lang es || true
  libretranslate --install-lang fr || true
  libretranslate --install-lang de || true
  libretranslate --install-lang zh || true
  libretranslate --install-lang ja || true
  libretranslate --install-lang bn || true
  libretranslate --install-lang ar || true
fi

exec libretranslate --host 0.0.0.0 --port ${PORT:-5000}
