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

# Install language models (English-centric pairs)
RUN argospm update && \
    argospm install translate-en_es && \
    argospm install translate-es_en && \
    argospm install translate-en_fr && \
    argospm install translate-fr_en && \
    argospm install translate-en_de && \
    argospm install translate-de_en && \
    argospm install translate-en_zh && \
    argospm install translate-zh_en && \
    argospm install translate-en_ja && \
    argospm install translate-ja_en && \
    argospm install translate-en_hi && \
    argospm install translate-hi_en && \
    argospm install translate-en_ar && \
    argospm install translate-ar_en && \
    argospm install translate-en_bn && \
    argospm install translate-bn_en

# Configure runtime
EXPOSE 5000
ENV PORT=5000
CMD ["libretranslate", "--host", "0.0.0.0", "--port", "5000", "--disable-web-ui", "--load-only", "en,es,hi,fr,ja,zh,de,ar,bn"]