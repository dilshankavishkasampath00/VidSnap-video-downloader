FROM node:20-bookworm-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        ffmpeg \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install yt-dlp
RUN python3 -m pip install --break-system-packages --no-cache-dir yt-dlp

WORKDIR /app

# Install Node dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy project
COPY . .

# Create downloads folder
RUN mkdir -p downloads

# Environment
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
CMD curl -f http://localhost:$PORT/health || exit 1

CMD ["npm", "start"]