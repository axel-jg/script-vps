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
    apt-get install -y software-properties-common

    echo "⬇️ Ajout du dépôt PHP..."
    add-apt-repository -y ppa:ondrej/php
    apt-get update -y

    echo "📦 Installation de PHP 8.2..."
    apt-get install -y php8.2 php8.2-cli php8.2-fpm php8.2-mysql
    ;;

  fedora|rhel|centos)
    echo "📦 Mise à jour des paquets (Fedora/RHEL/CentOS)..."
    dnf -y update
    dnf -y install dnf-plugins-core

    echo "⬇️ Ajout du dépôt Remi..."
    dnf module reset php -y
    dnf module enable php:remi-8.2 -y

    echo "📦 Installation de PHP 8.2..."
    dnf install -y php php-cli php-fpm php-mysqlnd
    ;;

  arch|archlinux)
    echo "📦 Mise à jour des paquets (Arch Linux)..."
    pacman -Syu --noconfirm

    echo "📦 Installation de PHP..."
    pacman -S --needed --noconfirm php php-fpm php-apache
    ;;

  *)
    echo "❌ Distribution non supportée : $DISTRO"
    echo "👉 Distributions supportées : Debian, Ubuntu, Fedora, RHEL, CentOS, Arch Linux"
    exit 1
    ;;
esac

# Vérification finale
if command -v php >/dev/null 2>&1; then
  echo "✅ PHP a été installé avec succès !"
  php -v
else
  echo "❌ L'installation de PHP a échoué."
  exit 1
fi