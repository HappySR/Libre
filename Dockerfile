FROM python:3.10-slim-bullseye

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libicu-dev \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install application dependencies
RUN pip install --no-cache-dir \
    libretranslate \
    argostranslate

# Install language models
RUN argospm update && \
    argospm install translate-en_es && \
    argospm install translate-es_en

# Configure runtime
EXPOSE 5000
ENV PORT=5000
CMD ["libretranslate", "--host", "0.0.0.0", "--port", "5000", "--disable-web-ui"]