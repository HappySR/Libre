FROM python:3.10-slim-bullseye AS builder

ARG LANGUAGES="en,hi,es,fr,de,zh,ja,bn,ar"
ENV LT_LOAD_ONLY=$LANGUAGES

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    gcc \
    g++ \
    libicu-dev && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install and configure models
RUN pip install --no-cache-dir libretranslate==1.6.4 && \
    /opt/venv/bin/libretranslate --update-models && \
    /opt/venv/bin/libretranslate --install-langs $LANGUAGES

# Runtime stage
FROM python:3.10-slim-bullseye
RUN apt-get update && \
    apt-get install -y --no-install-recommends libicu-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PORT=5000 \
    LT_LOAD_ONLY=$LANGUAGES

EXPOSE 5000
ENTRYPOINT ["sh", "-c", "libretranslate --host 0.0.0.0 --port $PORT --load-only \"$LT_LOAD_ONLY\""]