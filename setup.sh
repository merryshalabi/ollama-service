#!/bin/bash
set -e

echo "🚀 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "🔧 Copying systemd services..."
sudo cp /home/ubuntu/ollama.service /etc/systemd/system/ollama.service
sudo cp /home/ubuntu/ollama-ngrok.service /etc/systemd/system/ollama-ngrok.service


echo "🔁 Reloading systemd..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "🚀 Starting Ollama service..."
sudo systemctl enable --now ollama

echo "🚀 Starting Ngrok tunnel service..."
sudo systemctl enable --now ollama-ngrok

echo "⏳ Waiting for service to be ready..."
sleep 3

echo "📦 Pulling model as ubuntu user..."
sudo -u ubuntu ollama pull gemma3:1b

echo "🐍 Installing Python client in virtualenv..."
while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done
sudo apt update
sudo apt install -y python3 python3-pip python3-venv unzip

python3 -m venv /home/ubuntu/ollama-env
source /home/ubuntu/ollama-env/bin/activate
pip install --upgrade pip
pip install ollama

echo "🌐 Installing ngrok if needed..."
if ! command -v ngrok &> /dev/null
then
  wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  unzip -q ngrok-stable-linux-amd64.zip
  sudo mv ngrok /usr/local/bin
fi

# Optional: activate venv by default on SSH
echo "source ~/ollama-env/bin/activate" >> /home/ubuntu/.bashrc

echo "✅ DONE: Ollama + Ngrok services are live and ready"
