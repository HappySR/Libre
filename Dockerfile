FROM python:3.10-slim-bullseye

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libicu-dev && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install LibreTranslate
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir libretranslate==1.6.4

# Download only the required models during build
RUN libretranslate --update-models && \
    libretranslate --install-lang en && \
    libretranslate --install-lang hi && \
    libretranslate --install-lang es && \
    libretranslate --install-lang fr && \
    libretranslate --install-lang de && \
    libretranslate --install-lang zh && \
    libretranslate --install-lang ja && \
    libretranslate --install-lang bn && \
    libretranslate --install-lang ar

# Runtime configuration
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5000
ENTRYPOINT ["/entrypoint.sh"]
