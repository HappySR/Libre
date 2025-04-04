FROM python:3.10-slim-bullseye AS builder

ARG LANGUAGES="en,es,fr"  # Essential languages only
ENV LT_LOAD_ONLY=$LANGUAGES

# System dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libicu-dev \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install pinned dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    libretranslate==1.6.4 \
    argostranslate==1.9.6 \
    fastapi==0.95.2 \
    uvloop==0.17.0

# Pre-install models during build
RUN libretranslate --update_models && \
    for lang in $(echo $LANGUAGES | tr ',' ' '); do \
        libretranslate --install_lang $lang; \
    done

# Final stage
FROM python:3.10-slim-bullseye

# Runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libicu-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /root/.local/share/argos-translate /root/.local/share/argos-translate

ENV PATH="/opt/venv/bin:$PATH" \
    PORT=5000

EXPOSE $PORT
ENTRYPOINT ["libretranslate", "--host", "0.0.0.0", "--port", "$PORT"]