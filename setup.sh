#!/bin/bash

# RECOMMEND FOR UBUNTU / DEBIAN

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or use sudo."
  exit 1
fi

# Docker Check
if ! command -v docker &> /dev/null
then
  echo "Docker Engine is not installed. Please install it to continue."
  exit 1
fi

# Install golang
if ! command -v go &> /dev/null
then
  apt install golang gcc
fi

# Input
read -p "Enter domain to tailscale (e.g., tailscale.example.com): " HEADSCALE_DOMAIN
read -p "Enter domain to headscale UI (Don't same like tailscale connect): " HEADSCALE_UI_DOMAIN
read -p "Enter JWT Token for headscale UI: " HEADSCALE_JWT
read -p "Enter your email for TLS registration: (e.g., tlsregis@gmail.com) " EMAIL_TLS
read -p "Enter your Traefik/Cloudflare email: " CF_EMAIL
read -p "Enter your Cloudflare API Key: " CF_API

# Write file secret
echo CF_EMAIL > ./secrets/cloudflare_email
echo CF_API > ./secrets/cloudflare_api

# Headscale Config
sed -i "s|server_url:.*|server_url: https://$HEADSCALE_DOMAIN|g" ./headscale/config/config.yml

# Email
sed -i "s|email:.*|email: $EMAIL_TLS|g" ./traefik/traefik.yml
sed -i "s@traefik.certificatesResolvers.cloudflare.acme.email=.*@traefik.certificatesResolvers.cloudflare.acme.email=$EMAIL_TLS@g" ./docker-compose.yml

# JWT
sed -i "s@JWT_SECRET=.*@JWT_SECRET=$HEADSCALE_JWT@g" ./docker-compose.yml

# Routing
sed -i "s@Host(\`.*\`) # headscale-rule@Host(\`$HEADSCALE_DOMAIN\`) # headscale-rule@g" ./docker-compose.yml
sed -i "s@Host(\`.*\`) # ui-rule@Host(\`$HEADSCALE_UI_DOMAIN\`) # ui-rule@g" ./docker-compose.yml

# Success Config
echo "Done! Configuration updated."
echo "Run docker compose"

# Docker Compose Run
sudo docker compose up -d

# Success!
echo "Success!"