FROM python:3.10-slim-bullseye AS builder

ARG LANGUAGES="en,hi"
ENV LT_LOAD_ONLY=$LANGUAGES

# System dependencies - expanded set
RUN apt-get update && \
    apt-get install -y \
    gcc \
    g++ \
    libicu-dev \
    pkg-config \
    libssl-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Virtual environment with upgraded pip
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Install LibreTranslate with explicit dependencies
RUN pip install --no-cache-dir \
    libretranslate==1.6.4 \
    argostranslate==2.4.0 \
    fastapi==0.103.2 \
    uvloop==0.19.0

# Install models
RUN for lang in $(echo $LANGUAGES | tr ',' ' '); do \
        libretranslate --install-lang $lang; \
    done

# Final stage
FROM python:3.10-slim-bullseye

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libicu-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    LT_LOAD_ONLY=$LANGUAGES

EXPOSE ${PORT:-5000}
ENTRYPOINT ["sh", "-c", "libretranslate --host 0.0.0.0 --port ${PORT:-5000} --load-only \"$LT_LOAD_ONLY\""]
