# Base image
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY . .

# Build Vite frontend & Node backend
RUN npm run build

# Production image
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=10000

# Copy package files and install only production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy build artifacts and necessary assets from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public
COPY --from=builder /app/store_db.json ./store_db.json

EXPOSE 10000

CMD ["node", "dist/server.cjs"]
