#!/bin/bash

# Variables
BUILD_DIR="/var/www/html/code2Gen/builds"  # Répertoire source des fichiers générés
REPO_DIR="/OSOh2GEN/prompt"               # Répertoire du dépôt Git
BRANCH="auto-save"                        # Branche dédiée aux sauvegardes

# Étape 1 : Déplacer les fichiers de /builds vers /OSOh2GEN/prompt
echo "Déplacement des fichiers de $BUILD_DIR vers $REPO_DIR..."
mv $BUILD_DIR/* $REPO_DIR/ || { echo "Erreur : Impossible de déplacer les fichiers."; exit 1; }

# Étape 2 : Se déplacer dans le répertoire du dépôt
cd $REPO_DIR || { echo "Erreur : dépôt introuvable."; exit 1; }

# Étape 3 : Basculer sur la branche auto-save
git checkout $BRANCH || { echo "Erreur : impossible de basculer sur $BRANCH."; exit 1; }

# Étape 4 : Ajouter les fichiers déplacés au suivi Git
echo "Ajout des fichiers au suivi Git..."
git add . || { echo "Erreur : aucun fichier à ajouter."; exit 0; }

# Étape 5 : Faire un commit avec un message dynamique
echo "Création du commit..."
git commit -m "Backup automatique des prompts du $(date '+%Y-%m-%d %H:%M:%S')" || { echo "Aucun changement détecté."; exit 0; }

# Étape 6 : Pousser les modifications vers la branche auto-save
echo "Pousser les modifications vers la branche $BRANCH..."
git push origin $BRANCH || { echo "Erreur : impossible de pousser les modifications."; exit 1; }

echo "Sauvegarde et push automatiques terminés avec succès !"
