# Base image with Python
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy requirements.txt into the container
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install language models for LibreTranslate (optional: adjust as needed)
RUN libretranslate --download-models

# Copy all files into the container
COPY . .

# Expose the port LibreTranslate runs on
EXPOSE 5000

# Command to run the server
CMD ["libretranslate"]
