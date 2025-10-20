#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec des privilèges root."
  exit 1
fi

if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  echo "Impossible de détecter la distribution (pas de /etc/os-release)"
  exit 1
fi

ARCHITECTURE=$(uname -m)

echo "🔎 Distribution détectée : $DISTRO"
echo "🔎 Architecture détectée : $ARCHITECTURE"

case "$DISTRO" in
  debian|ubuntu)
    echo "📦 Mise à jour des paquets (Debian/Ubuntu)..."
    apt-get update -y
    apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

    echo "🔐 Ajout de la clé GPG Docker..."
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "📦 Ajout du repository Docker..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DISTRO \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "📦 Installation de Docker..."
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ;;

  fedora|rhel|centos)
    echo "📦 Mise à jour des paquets (Fedora/RHEL/CentOS)..."
    dnf -y update
    dnf -y install dnf-plugins-core

    echo "📦 Ajout du repository Docker..."
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    echo "📦 Installation de Docker..."
    dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ;;

  arch|archlinux)
    echo "📦 Mise à jour des paquets (Arch Linux)..."
    pacman -Syu --noconfirm
    echo "📦 Installation de Docker..."
    pacman -S --needed --noconfirm docker
    ;;

  *)
    echo "❌ Distribution non supportée : $DISTRO"
    echo "👉 Distributions supportées : Debian, Ubuntu, Fedora, RHEL, CentOS, Arch Linux"
    exit 1
    ;;
esac

systemctl enable docker
systemctl start docker

if command -v docker >/dev/null 2>&1; then
  echo "✅ Docker a été installé avec succès !"
  docker --version
else
  echo "❌ L'installation de Docker a échoué."
  exit 1
fi
