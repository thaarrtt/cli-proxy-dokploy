# ─────────────────────────────────────────────────────────────
# Stage 1 — Build the single-file management HTML with Bun/Vite
# The source is cloned directly from GitHub — no local copy needed.
# ─────────────────────────────────────────────────────────────
FROM oven/bun:1.3-alpine AS builder

ARG VERSION=latest
ARG REPO=https://github.com/router-for-me/Cli-Proxy-API-Management-Center.git
ENV VERSION=${VERSION}

# git is needed to clone the source
RUN apk add --no-cache git

WORKDIR /app

# Clone the upstream repo directly inside the build stage.
# This makes the Dockerfile fully self-contained for Dokploy.
RUN git clone --depth=1 ${REPO} .

# Install dependencies
RUN bun install --frozen-lockfile

# Build — vite-plugin-singlefile produces a single dist/index.html
RUN bun run build

# Rename to management.html (matches the backend's expected path)
RUN mv /app/dist/index.html /app/dist/management.html

# ─────────────────────────────────────────────────────────────
# Stage 2 — Serve with Nginx (Alpine, ~8 MB final image)
# ─────────────────────────────────────────────────────────────
FROM nginx:1.27-alpine AS runner

# Remove the default Nginx welcome page
RUN rm /etc/nginx/conf.d/default.conf

# Only the nginx.conf from our build context is needed here
COPY nginx.conf /etc/nginx/conf.d/management.conf

# Copy the compiled single-file HTML from builder stage
COPY --from=builder /app/dist/management.html /usr/share/nginx/html/management.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost/management.html || exit 1
