#!/bin/bash

echo "🚀 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "📦 Pulling model..."
ollama pull gemma3:1b

echo "🔧 Starting Ollama service..."
sudo systemctl enable --now ollama
