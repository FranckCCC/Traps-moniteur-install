#!/bin/bash
# Ce script doit être exécuté avec les privilèges root (via sudo)
# Sauvegarde des configurations et installation de Mosquitto, Apache, PHP et du dépôt Git.

# Définir une variable DATE pour les suffixes de sauvegarde
DATE=$(date +%F_%H-%M-%S)

# Mettre à jour la liste des paquets
apt-get update

# Installer Mosquitto et les clients MQTT s'ils ne sont pas déjà installés
if ! dpkg -l | grep -q mosquitto; then
    apt-get install -y mosquitto mosquitto-clients
fi

# Sauvegarder la configuration Mosquitto existante (si présente)
if [ -f /etc/mosquitto/conf.d/listeners.conf ]; then
    cp /etc/mosquitto/conf.d/listeners.conf /etc/mosquitto/conf.d/listeners.conf.bak_$DATE
    echo "Configuration Mosquitto sauvegardée en /etc/mosquitto/conf.d/listeners.conf.bak_$DATE"
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

# Installer PHP et le module Apache pour PHP si non présents
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

# Sauvegarder le répertoire web existant s'il n'est pas vide
if [ "$(ls -A /var/www/html)" ]; then
    echo "Le répertoire /var/www/html contient déjà des fichiers. Sauvegarde en cours..."
    cp -r /var/www/html /var/www/html_backup_$DATE
    echo "Sauvegarde réalisée dans /var/www/html_backup_$DATE"
    
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
