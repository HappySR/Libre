#!/bin/sh
set -ex

# Install all models if not already installed
if [ ! -d "/root/.local/share/argos-translate/packages" ]; then
  libretranslate --update-models
  libretranslate --install-lang en || true
  libretranslate --install-lang hi || true
  libretranslate --install-lang es || true
  libretranslate --install-lang fr || true
  libretranslate --install-lang de || true
  libretranslate --install-lang zh || true
  libretranslate --install-lang ja || true
  libretranslate --install-lang bn || true
  libretranslate --install-lang ar || true
fi

# Start the LibreTranslate server
exec libretranslate --host 0.0.0.0 --port $PORT
