# Psych Online server — optimized for Render.com (WebSocket + node-canvas native deps)
FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 make g++ \
    libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json package-lock.json ./
COPY prisma ./prisma

RUN npm ci

COPY . .

RUN npm run render-build

ENV NODE_ENV=production

# Render sets PORT; Colyseus reads process.env.PORT
CMD ["node", "build/index.js"]
