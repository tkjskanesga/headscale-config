# Headscale Configuration Self-Host

This repository contains the configuration files for deploying a self-hosted Headscale control server with Traefik as a reverse proxy and Cloudflare for TLS.

## 📦 Installation

### Prerequisites

- A Linux VPS or local server.
- Docker and Docker Compose installed.
- A domain name (FQDN) pointing to your server IP.

### Quick Start

1. Clone the repository

   ```bash
   git clone https://github.com/tkjskanesga/headscale-config.git ./headscale
   cd headscale
   ```

2. Configure Headscale: Edit `headscale/config/config.yml` and update the `server_url` with your domain:

   ```bash
   #
   # https://myheadscale.example.com:443
   #
   server_url: http://127.0.0.1:8080 # > Change this! like https://tailscale.example.com

   # Address to listen to / bind to on
   ```

   View more configuration on [original repository](https://github.com/juanfont/headscale/blob/main/config-example.yaml)

3. Configure Traefik: Edit `traefik/traefik.yml` and set your email address for TLS certificate registration.
4. Set Cloudflare Secrets: Go to the `secrets/` folder and update the following files:
   - `cloudflare_email`: Enter your Cloudflare account email.
   - `cloudflare_api`: Enter your Cloudflare API Token (Global or Scoped).
5. Deploy.

   ```bash
   docker-compose up -d
   ```

6. Setup Dashboard & API: Access your dashboard to set up your username and password. If you need an API key for the dashboard/integration, run:

   ```bash
   docker exec -it headscale headscale apikey create -expiration 7510d # 7510 days
   ```

7. Done! 🎉
