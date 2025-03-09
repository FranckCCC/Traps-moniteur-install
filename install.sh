#!/bin/bash
# Ce script doit être exécuté avec les privilèges root (via sudo)

# Mettre à jour la liste des paquets
apt-get update

# Installer Mosquitto et les clients MQTT s'ils ne le sont pas déjà
if ! dpkg -l | grep -q mosquitto; then
    apt-get install -y mosquitto mosquitto-clients
fi

# Créer ou mettre à jour le fichier de configuration pour Mosquitto
cat <<EOF > /etc/mosquitto/conf.d/listeners.conf
listener 1883
protocol mqtt

listener 1884
protocol websockets
EOF

# Redémarrer Mosquitto et activer son démarrage automatique
systemctl restart mosquitto
systemctl enable mosquitto

# Installer Apache2 si non présent
if ! dpkg -l | grep -q apache2; then
    apt-get install -y apache2
else
    echo "Apache2 est déjà installé."
fi

# Installer PHP et le module Apache si non présents
if ! dpkg -l | grep -q php; then
    apt-get install -y php libapache2-mod-php
else
    echo "PHP et le module Apache PHP sont déjà installés."
fi

# Installer Git si non présent
if ! dpkg -l | grep -q git; then
    apt-get install -y git
else
    echo "Git est déjà installé."
fi

# Vérifier si le répertoire /var/www/html n'est pas vide
if [ "$(ls -A /var/www/html)" ]; then
    echo "Le répertoire /var/www/html contient déjà des fichiers."
    echo "Voulez-vous vider ce répertoire et cloner le dépôt ? (o/n)"
    read -r answer
    if [ "$answer" = "o" ]; then
        rm -rf /var/www/html/*
    else
        echo "Installation interrompue pour éviter d'écraser des données existantes."
        exit 1
    fi
fi

# Cloner le dépôt FranckCCC/TrapsMoniteurMQTT dans le répertoire web
git clone https://github.com/FranckCCC/TrapsMoniteurMQTT /var/www/html

echo "Installation terminée avec succès."
