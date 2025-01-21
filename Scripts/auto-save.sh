#!/bin/bash

# Chemins des dossiers
SOURCE_DIR="/testryan/builds"
DEST_DIR="/OSOh2GEN/Prompt"  # Dossier de destination correct
GIT_DIR="/OSOh2GEN"  # Répertoire du dépôt Git
BRANCH="auto-save"
COMMIT_MESSAGE="Auto-save des builds générés"

# Vérifier si le dossier de destination existe
if [ ! -d "$DEST_DIR" ]; then
    echo "Erreur : Le dossier $DEST_DIR n'existe pas."
    exit 1
fi

# Déplacer les fichiers avec sudo
echo "Déplacement des fichiers de $SOURCE_DIR vers $DEST_DIR avec sudo..."
sudo mv $SOURCE_DIR/* $DEST_DIR/ 2>/dev/null || echo "Aucun fichier à déplacer."
echo "Déplacement terminé."

# Se déplacer dans le répertoire du dépôt Git
cd "$GIT_DIR" || exit 1

# S'assurer qu'on est bien dans un dépôt Git
if [ ! -d ".git" ]; then
    echo "Erreur : Ce n'est pas un dépôt Git."
    exit 1
fi

# Basculer sur la branche auto-save
git checkout "$BRANCH" || git checkout -b "$BRANCH"

# Ajouter les fichiers déplacés dans Git
echo "Ajout des fichiers dans Git..."
git add "$DEST_DIR"
if git commit -m "$COMMIT_MESSAGE"; then
    echo "Les modifications ont été committées dans la branche $BRANCH."
else
    echo "Aucune modification à committer."
fi

# Optionnel : Pousser les changements sur le dépôt distant
echo "Poussée des changements sur la branche distante..."
git push origin "$BRANCH"
echo "Les modifications ont été poussées avec succès."
