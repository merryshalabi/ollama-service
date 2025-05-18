#!/bin/bash
set -e

echo "🚀 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "🔧 Copying systemd service..."
sudo cp /home/ubuntu/ollama.service /etc/systemd/system/ollama.service

echo "🔁 Reloading systemd..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "🚀 Starting Ollama service..."
sudo systemctl enable --now ollama

echo "⏳ Waiting for service to be ready..."
sleep 3

echo "📦 Pulling model as ubuntu user..."
sudo -u ubuntu ollama pull gemma3:1b

echo "🐍 Installing Python client in virtualenv..."
# Wait for apt to be free
while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done
sudo apt update
sudo apt install -y python3 python3-pip python3-venv

python3 -m venv /home/ubuntu/ollama-env
source /home/ubuntu/ollama-env/bin/activate
pip install --upgrade pip
pip install ollama

# Optional: activate venv by default on SSH
echo "source ~/ollama-env/bin/activate" >> /home/ubuntu/.bashrc

echo "✅ DONE: Ollama installed, service running, and Python client ready in venv"
