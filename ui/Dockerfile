# ─────────────────────────────────────────────────────────────
# Stage 1 — Build the single-file management HTML with Bun/Vite
# ─────────────────────────────────────────────────────────────
FROM oven/bun:1.3-alpine AS builder

ARG VERSION=latest
ENV VERSION=${VERSION}

WORKDIR /app

# Install dependencies first (layer-cached)
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# Copy source and build
COPY . .
RUN bun run build

# The Vite build produces a single dist/index.html (via vite-plugin-singlefile)
# Rename it to management.html to match the backend's expected path
RUN mv /app/dist/index.html /app/dist/management.html

# ─────────────────────────────────────────────────────────────
# Stage 2 — Serve with Nginx (Alpine, ~8 MB final image)
# ─────────────────────────────────────────────────────────────
FROM nginx:1.27-alpine AS runner

# Remove the default Nginx welcome page
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/management.conf

# Copy the built single-file HTML
COPY --from=builder /app/dist/management.html /usr/share/nginx/html/management.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost/management.html || exit 1
