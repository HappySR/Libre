#!/bin/sh
set -ex

# Start the LibreTranslate server
exec libretranslate --host 0.0.0.0 --port $PORT
