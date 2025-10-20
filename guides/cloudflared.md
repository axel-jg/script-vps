# ☁️ Script d'installation de Cloudflared

---

## 📌 Distributions supportées

- Arch Linux 🌀
- Fedora 🟣
- RHEL / CentOS 🔵
- Debian 🌀
- Ubuntu 🟠

---

## 📥 Installation

1. **Cloner le dépôt :**
   ```bash
   git clone https://github.com/Fly072pp/script-vps.git
   ```

2. **Se déplacer dans le dossier :**
   ```bash
   cd script-vps/scripts/
   ```

3. **Rendre le script exécutable :**
   ```bash
   chmod +x cloudflared.sh
   ```

4. **Lancer le script :**
   ```bash
   sudo ./cloudflared.sh
   ```

---

## 🛠️ Dépannage (Troubleshooting)

- **Erreur :** `dpkg: dependency problems`  
  💡 **Solution :** Exécuter :
  ```bash
  sudo apt-get install -f -y
  ```

- **Erreur :** `pacman: keyring`  
  💡 **Solution :** Exécuter :
  ```bash
  sudo pacman -S archlinux-keyring --noconfirm
  ```

- **Erreur :** `cloudflared: command not found`  
  💡 **Solution :** Vérifier que `/usr/local/bin` ou `/usr/bin` est bien dans votre PATH.
  
**Autres erreurs ?** Crée une Issue