# ☁️ Script d'installation de PHP

---

## 📌 Distributions supportées

- Arch Linux 🌀
- Fedora 🟣
- RHEL / CentOS 🔵
- Debian 🌀
- Ubuntu 🟠

---

## 📥 Installation PHP 8.2

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
   chmod +x php8.2.sh
   ```

4. **Lancer le script :**
   ```bash
   sudo ./php8.2.sh
   ```
   

## 📥 Installation PHP 8.3

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
   chmod +x php8.3.sh
   ```

4. **Lancer le script :**
   ```bash
   sudo ./php8.3.sh
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

- **Erreur :** `php: command not found`  
  💡 **Solution :** Vérifier que `/usr/local/bin` ou `/usr/bin` est bien dans votre PATH.
  
**Autres erreurs ?** Crée une Issue