# Base image with Python
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy requirements.txt into the container
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Manually download the language models using argos-translate
RUN mkdir -p /usr/share/argos-translate && \
    cd /usr/share/argos-translate && \
    curl -L -o en_es.argosmodel https://github.com/argosopentech/argos-translate/releases/download/v1.0/en_es.argosmodel && \
    curl -L -o es_en.argosmodel https://github.com/argosopentech/argos-translate/releases/download/v1.0/es_en.argosmodel && \
    argos-translate --install /usr/share/argos-translate/en_es.argosmodel && \
    argos-translate --install /usr/share/argos-translate/es_en.argosmodel

# Copy all files into the container
COPY . .

# Expose the port LibreTranslate runs on
EXPOSE 5000

# Command to run the server
CMD ["libretranslate"]
