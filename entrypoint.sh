#!/bin/sh
set -ex

# Install remaining models on first run
libretranslate --install-lang fr || true
libretranslate --install-lang de || true
libretranslate --install-lang zh || true
libretranslate --install-lang ja || true
libretranslate --install-lang bn || true
libretranslate --install-lang ar || true

# Start the LibreTranslate server
exec libretranslate --host 0.0.0.0 --port $PORT
