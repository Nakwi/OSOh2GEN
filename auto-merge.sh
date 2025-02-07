#!/bin/bash

# Variables
REPO_PATH="/OSOh2GEN"  # Chemin absolu vers ton dépôt
AUTO_SAVE_BRANCH="auto-save"  # Branche contenant les sauvegardes
MAIN_BRANCH="main"  # Branche principale
MERGE_MESSAGE="Fusion hebdomadaire depuis auto-save avec remplacement du dossier safe : $(date '+%Y-%m-%d')"

# Naviguer dans le répertoire du dépôt
cd "$REPO_PATH" || { echo "Le chemin $REPO_PATH est introuvable."; exit 1; }

# Vérifier si le dossier est un dépôt Git
if [ ! -d ".git" ]; then
    echo "Le dossier $REPO_PATH n'est pas un dépôt Git."
    exit 1
fi

# Passer à la branche main et la mettre à jour
git checkout $MAIN_BRANCH || { echo "La branche $MAIN_BRANCH n'existe pas."; exit 1; }
git pull origin $MAIN_BRANCH

# S'assurer que la branche auto-save est à jour
git checkout $AUTO_SAVE_BRANCH || { echo "La branche $AUTO_SAVE_BRANCH n'existe pas."; exit 1; }
git pull origin $AUTO_SAVE_BRANCH

# Passer à main et fusionner auto-save avec l'option pour fusionner des historiques non liés
git checkout $MAIN_BRANCH
git merge $AUTO_SAVE_BRANCH --allow-unrelated-histories -m "$MERGE_MESSAGE"

# Pousser les modifications dans main
git push origin $MAIN_BRANCH || { echo "Le push vers $MAIN_BRANCH a échoué."; exit 1; }

# Revenir à la branche auto-save après la fusion
git checkout auto-save
echo "Retour à la branche auto-save après la fusion."


echo "La fusion hebdomadaire avec remplacement du dossier /safe est terminée avec succès."
