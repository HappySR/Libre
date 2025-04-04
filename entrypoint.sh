#!/bin/sh
set -ex

if [ ! -d "/root/.local/share/argos-translate/packages" ]; then
  libretranslate --update_models  # <-- Fix hyphen to underscore
  libretranslate --install_lang en || true  # <-- Fix hyphen to underscore
  libretranslate --install_lang hi || true
  libretranslate --install_lang es || true
  libretranslate --install_lang fr || true
  libretranslate --install_lang de || true
  libretranslate --install_lang zh || true
  libretranslate --install_lang ja || true
  libretranslate --install_lang bn || true
  libretranslate --install_lang ar || true
fi

exec libretranslate --host 0.0.0.0 --port ${PORT:-5000}
