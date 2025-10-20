#!/bin/bash

# Vérifie si root
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec des privilèges root."
  exit 1
fi

# Détecte la distribution
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
    apt-get install -y curl gnupg lsb-release

    if [[ "$ARCHITECTURE" == "x86_64" ]]; then
        URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb"
    elif [[ "$ARCHITECTURE" == "aarch64" ]]; then
        URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb"
    else
        echo "❌ Architecture non supportée: $ARCHITECTURE"
        exit 1
    fi

    echo "⬇️ Téléchargement du paquet cloudflared..."
    curl -L -o cloudflared.deb "$URL"

    echo "📦 Installation de cloudflared..."
    dpkg -i cloudflared.deb || apt-get install -f -y
    rm -f cloudflared.deb
    ;;

  fedora|rhel|centos)
    echo "📦 Mise à jour des paquets (Fedora/RHEL/CentOS)..."
    dnf -y update
    dnf -y install curl gnupg redhat-lsb-core

    if [[ "$ARCHITECTURE" == "x86_64" ]]; then
        URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm"
    elif [[ "$ARCHITECTURE" == "aarch64" ]]; then
        URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-aarch64.rpm"
    else
        echo "❌ Architecture non supportée: $ARCHITECTURE"
        exit 1
    fi

    echo "⬇️ Téléchargement du paquet cloudflared..."
    curl -L -o cloudflared.rpm "$URL"

    echo "📦 Installation de cloudflared..."
    dnf -y install ./cloudflared.rpm
    rm -f cloudflared.rpm
    ;;

  arch|archlinux)
    echo "📦 Mise à jour des paquets (Arch Linux)..."
    pacman -Syu --noconfirm
    pacman -S --needed --noconfirm git base-devel

    echo "⬇️ Installation de cloudflared depuis l'AUR..."
    sudo -u $(logname) bash -c "
      cd /tmp &&
      git clone https://aur.archlinux.org/cloudflared-bin.git &&
      cd cloudflared-bin &&
      makepkg -si --noconfirm
    "
    ;;

  *)
    echo "❌ Distribution non supportée : $DISTRO"
    echo "👉 Distributions supportées : Debian, Ubuntu, Fedora, RHEL, CentOS, Arch Linux"
    exit 1
    ;;
esac

# Vérification finale
if command -v cloudflared >/dev/null 2>&1; then
  echo "✅ cloudflared a été installé avec succès !"
  cloudflared --version
else
  echo "❌ L'installation de cloudflared a échoué."
  exit 1
fi
