#!/bin/sh
set -ex

# Download all models on first run
if [ ! -d "/root/.local/share/argos-translate/packages" ]; then
  libretranslate --update-models
  libretranslate --install-langs all
fi

# Start server with all languages
exec libretranslate --host 0.0.0.0 --port $PORT
