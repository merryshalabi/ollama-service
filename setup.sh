#!/bin/bash

set -e

echo "🚀 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "📦 Pulling model..."
ollama pull gemma3:1b

echo "🔧 Copying custom systemd service..."
sudo cp ollama.service /etc/systemd/system/ollama.service

echo "🔁 Reloading and starting systemd service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart ollama
sudo systemctl enable ollama

echo "✅ Ollama running on \$OLLAMA_HOST:11434"
