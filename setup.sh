#!/bin/bash

set -e

echo "🚀 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "📦 Pulling model..."
ollama pull gemma3:1b

echo "🔧 Updating Ollama systemd to bind to 0.0.0.0..."

# Patch the systemd service
sudo sed -i 's|^ExecStart=.*|ExecStart=/usr/local/bin/ollama serve --host 0.0.0.0|' /etc/systemd/system/ollama.service

echo "🔁 Reloading and restarting Ollama service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart ollama
sudo systemctl enable ollama

echo "✅ Ollama is deployed and listening on 0.0.0.0:11434"
