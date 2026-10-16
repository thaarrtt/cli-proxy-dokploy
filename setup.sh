#!/usr/bin/env bash
# setup.sh — first-time setup for the CLI Proxy Dokploy stack
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> CLI Proxy API Management Center — Dokploy Setup"
echo ""

# 1. Clone the Management UI source into ./ui
if [ ! -d "$SCRIPT_DIR/ui/.git" ]; then
  echo "--> Cloning Management UI source..."
  git clone --depth=1 \
    https://github.com/router-for-me/Cli-Proxy-API-Management-Center.git \
    "$SCRIPT_DIR/ui"
  echo "    Done."
else
  echo "--> ui/ already exists, pulling latest..."
  git -C "$SCRIPT_DIR/ui" pull --ff-only
fi

# Copy the Dockerfile and nginx.conf into ui/ (overwrite if already there)
cp "$SCRIPT_DIR/ui/Dockerfile" "$SCRIPT_DIR/ui/Dockerfile" 2>/dev/null || true
cp "$SCRIPT_DIR/ui/nginx.conf" "$SCRIPT_DIR/ui/nginx.conf" 2>/dev/null || true

# 2. Create .env from example if it doesn't exist
if [ ! -f "$SCRIPT_DIR/.env" ]; then
  cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
  echo ""
  echo "==> Created .env from .env.example"
  echo "    IMPORTANT: Open .env and set MANAGEMENT_PASSWORD before starting!"
  echo ""
else
  echo "--> .env already exists, skipping."
fi

echo ""
echo "==> Setup complete. Next steps:"
echo ""
echo "  1. Edit .env and set a strong MANAGEMENT_PASSWORD"
echo "  2. Run:  docker compose up -d"
echo "  3. Open: http://<your-server>:8080/management.html"
echo "  4. Connect to the API at: http://<your-server>:8317"
echo ""
