#!/bin/bash
# Ce script doit être exécuté avec les privilèges root (via sudo)

# Mettre à jour la liste des paquets
apt-get update

# Installer Mosquitto et les clients MQTT
apt-get install -y mosquitto mosquitto-clients

# Créer un fichier de configuration pour définir les deux listeners
cat <<EOF > /etc/mosquitto/conf.d/listeners.conf
listener 1883
protocol mqtt

listener 1884
protocol websockets
EOF

# Redémarrer Mosquitto pour prendre en compte la nouvelle configuration
systemctl restart mosquitto

# S'assurer que Mosquitto se lance automatiquement au démarrage
systemctl enable mosquitto

# Installer Apache2, PHP, le module PHP pour Apache et Git
apt-get install -y apache2 php libapache2-mod-php git

# (Optionnel) Supprimer la page d’accueil par défaut d'Apache
rm -f /var/www/html/index.html

# Cloner le dépôt FranckCCC/TrapsMoniteurMQTT dans le dossier racine du serveur PHP
git clone https://github.com/FranckCCC/TrapsMoniteurMQTT /var/www/html

echo "Installation terminée avec succès."
