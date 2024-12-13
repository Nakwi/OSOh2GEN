#!/bin/bash

# Variables
BUILD_DIR="/var/www/html/code2Gen/builds"  # Répertoire des fichiers générés
REPO_DIR="/var/www/html/code2Gen"         # Répertoire du dépôt Git
BRANCH="auto-save"                        # Branche dédiée aux sauvegardes

# Se déplacer dans le répertoire du dépôt
cd $REPO_DIR || { echo "Erreur : dépôt introuvable."; exit 1; }

# Basculer sur la branche auto-save
git checkout $BRANCH || { echo "Erreur : impossible de basculer sur $BRANCH."; exit 1; }

# Ajouter les fichiers générés au suivi Git
git add $BUILD_DIR/* || { echo "Erreur : aucun fichier à ajouter."; exit 0; }

# Faire un commit avec un message dynamique
git commit -m "Backup automatique des fichiers générés du $(date '+%Y-%m-%d %H:%M:%S')" || { echo "Aucun changement détecté."; exit 0; }

# Pousser les modifications vers la branche auto-save
git push origin $BRANCH || { echo "Erreur : impossible de pousser les modifications."; exit 1; }

# Supprimer les fichiers après le commit et le push réussi
rm -rf $BUILD_DIR/* || { echo "Erreur : impossible de supprimer les fichiers dans $BUILD_DIR."; exit 1; }

echo "Sauvegarde automatique et suppression des fichiers terminées avec succès !"
