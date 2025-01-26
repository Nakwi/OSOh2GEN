#!/bin/bash

# Variables
REPO_PATH="/OSOh2GEN"  # Remplace par le chemin absolu de ton dossier OSOh2GEN
BRANCH_NAME="auto-save"
COMMIT_MESSAGE="Auto-save $(date '+%Y-%m-%d %H:%M:%S')"

# Naviguer dans le répertoire du dépôt
cd "$REPO_PATH" || { echo "Le chemin $REPO_PATH est introuvable."; exit 1; }

# Vérifier si le dossier est un dépôt Git
if [ ! -d ".git" ]; then
    echo "Le dossier $REPO_PATH n'est pas un dépôt Git."
    exit 1
fi

# Passer à la branche auto-save ou la créer si elle n'existe pas
git checkout $BRANCH_NAME 2>/dev/null || git checkout -b $BRANCH_NAME

# Ajouter les fichiers HTML du dossier 'safe' uniquement
git add safe/*.html

# Vérifier si des fichiers ont été ajoutés (évite les commits vides)
if [ -n "$(git diff --cached)" ]; then
    # Commit avec un message horodaté
    git commit -m "$COMMIT_MESSAGE"
    echo "Commit réalisé avec succès : $COMMIT_MESSAGE"

    # Push vers la branche auto-save
    git push origin $BRANCH_NAME
    echo "Les modifications ont été poussées vers la branche $BRANCH_NAME."
else
    echo "Aucune modification détectée, aucun commit n'a été réalisé."
fi
