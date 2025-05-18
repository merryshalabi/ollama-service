#!/bin/bash
set -e

echo "🚀 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "🔧 Copying service..."
sudo cp ollama.service /etc/systemd/system/ollama.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now ollama

echo "📦 Pulling model as ubuntu..."
sudo -u ubuntu ollama pull gemma3:1b

echo "🐍 Installing Python client..."
sudo apt update
sudo apt install -y python3 python3-pip
pip3 install --user ollama

echo "✅ Deployment complete. Ollama + Python client ready on localhost:11434."
