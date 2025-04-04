FROM python:3.10-slim-bullseye AS builder

ARG LANGUAGES="en,hi"
ENV LT_LOAD_ONLY=$LANGUAGES

# System dependencies
RUN apt-get update && \
    apt-get install -y \
    gcc \
    g++ \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install LibreTranslate
RUN pip install --no-cache-dir libretranslate==1.6.4

# Install models without updating
RUN for lang in $(echo $LANGUAGES | tr ',' ' '); do \
        libretranslate --install-lang $lang && \
        echo "Successfully installed $lang"; \
    done

# Final stage
FROM python:3.10-slim-bullseye

# Runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libicu-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    LT_LOAD_ONLY=$LANGUAGES

# Railway configuration
EXPOSE ${PORT:-5000}
ENTRYPOINT ["sh", "-c", "libretranslate --host 0.0.0.0 --port ${PORT:-5000} --load-only \"$LT_LOAD_ONLY\""]
