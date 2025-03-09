# Traps-moniteur-install


# Installation de TrapsMoniteurMQTT avec Sauvegarde et Rollback

Ce repository contient un script d'installation permettant de mettre en place un environnement comprenant :
- Un broker MQTT (Mosquitto) configuré pour écouter sur le port **1883** (MQTT) et **1884** (WebSockets).
- Un serveur web Apache2 avec PHP.
- Le clonage du dépôt [FranckCCC/TrapsMoniteurMQTT](https://github.com/FranckCCC/TrapsMoniteurMQTT) dans le répertoire `/var/www/html`.

Le script inclut également des mécanismes de sauvegarde pour pouvoir effectuer un rollback en cas de problème.

---

## Structure du Repository
install-trapsmoniteur/ ├── README.md └── install.sh


- **README.md** : Ce fichier d'explication.
- **install.sh** : Le script d'installation.

---

## Pré-requis

- Un Raspberry Pi ou une machine sous une distribution Linux compatible (comme PI OS).
- Accès en ligne de commande avec les privilèges root (via `sudo`).
- Une connexion Internet pour télécharger les paquets et cloner les dépôts GitHub.

---

## Utilisation

1. **Cloner le repository sur votre machine :**

   ```bash
   git clone https://github.com/FranckCCC/Traps-moniteur-install.git

2. **Se déplacer dans le répertoire cloné :**

   ```bash
   cd Traps-moniteur-install

3. **Exécuter le script avec les privilèges root :**

   ```bash
   sudo ./install.sh


## Fonctionnement du Script
Le script effectue les étapes suivantes :

Mise à jour des paquets :
Il lance une mise à jour de la liste des paquets disponibles avec apt-get update.

Installation de Mosquitto :
Si Mosquitto et Mosquitto-clients ne sont pas déjà installés, le script les installe.

Sauvegarde de la configuration existante :
Si le fichier /etc/mosquitto/conf.d/listeners.conf existe, il est sauvegardé avec un suffixe indiquant la date et l'heure.
Création de la nouvelle configuration :
Le fichier est généré avec deux listeners :
Port 1883 pour le protocole MQTT.
Port 1884 pour le protocole WebSockets.
Redémarrage et activation :
Le service Mosquitto est redémarré et activé pour se lancer automatiquement au démarrage.
Installation d'Apache2, PHP et Git :
Le script vérifie si Apache2, PHP (et le module Apache pour PHP) ainsi que Git sont installés. S'ils ne le sont pas, ils sont installés automatiquement.

Gestion du répertoire web (/var/www/html) :
Si le répertoire contient déjà des fichiers, une sauvegarde complète est réalisée (copie dans un dossier /var/www/html_backup_DATE).
Ensuite, le script demande à l'utilisateur s'il souhaite vider ce répertoire pour cloner le dépôt. En cas de refus, l'installation s'interrompt afin d'éviter d'écraser des données existantes.

Clonage du dépôt :
Le dépôt FranckCCC/TrapsMoniteurMQTT est cloné dans le répertoire /var/www/html.

Rollback
En cas de problème avec l'installation, les sauvegardes réalisées permettent de revenir en arrière manuellement :

Configuration Mosquitto :
Remplacez le fichier /etc/mosquitto/conf.d/listeners.conf par la sauvegarde réalisée (exemple : /etc/mosquitto/conf.d/listeners.conf.bak_YYYY-MM-DD_HH-MM-SS) et redémarrez Mosquitto.

Répertoire web :
Si nécessaire, restaurez le répertoire /var/www/html en récupérant les fichiers depuis le dossier de sauvegarde (/var/www/html_backup_DATE).

Vous pouvez également créer un script de rollback personnalisé pour automatiser ces restaurations.

Remarques
Attention aux modifications existantes :
Le script demande une confirmation avant de vider le répertoire /var/www/html afin d'éviter toute perte de données.
