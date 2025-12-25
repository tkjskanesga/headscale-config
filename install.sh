#!/bin/bash

# > curl -fsSL https://raw.githubusercontent.com/tkjskanesga/headscale-config/refs/heads/main/install.sh | bash

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or use sudo."
  exit 1
fi

DEPS=("git:git" "unzip:unzip" "zip:zip" "go:golang" "gcc:build-essential" "curl:curl")

echo "Checking system dependencies..."
for dep in "${DEPS[@]}"; do
  CMD=${dep%%:*}
  PKG=${dep##*:}
  if ! command -v "$CMD" &> /dev/null; then
    echo "Installing $PKG..."
    apt update && apt install -y "$PKG"
  fi
done

if [ ! -d "$DIRECTORY" ]; then
  git clone https://github.com/tkjskanesga/headscale-config.git ./headscale
fi

cd ./headscale

chmod +x setup.sh
sudo setup.sh