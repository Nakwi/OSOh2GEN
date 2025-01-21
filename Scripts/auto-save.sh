#!/bin/bash

# Chemins des dossiers
SOURCE_DIR="/testryan/builds"
DEST_DIR="/OSOH2GEN/Prompt"
BRANCH="auto-save"
COMMIT_MESSAGE="Auto-save des builds générés"

# Déplacer les fichiers avec sudo
move_files() {
    echo "Déplacement des fichiers de $SOURCE_DIR vers $DEST_DIR avec sudo..."
    sudo mv "$SOURCE_DIR"/* "$DEST_DIR"/ 2>/dev/null || echo "Aucun fichier à déplacer."
    echo "Déplacement terminé."
}

# Ajouter et committer dans Git (sans sudo)
git_commit() {
    echo "Ajout des fichiers dans Git..."
    cd "$DEST_DIR" || exit

    # Vérifier si on est dans un dépôt Git
    if [ ! -d ".git" ]; then
        echo "Erreur : Ce dossier n'est pas un dépôt Git."
        exit 1
    fi

    # Basculer sur la branche auto-save
    git checkout "$BRANCH" || git checkout -b "$BRANCH"

    # Ajouter les fichiers et committer
    git add .
    if git commit -m "$COMMIT_MESSAGE"; then
        echo "Les modifications ont été committées dans la branche $BRANCH."
    else
        echo "Aucune modification à committer."
    fi
}

# Optionnel : Pousser les changements sur le dépôt distant (sans sudo)
git_push() {
    echo "Poussée des changements sur la branche distante..."
    git push origin "$BRANCH"
    echo "Les modifications ont été poussées avec succès."
}

# Exécution des tâches
echo "Lancement du script d'auto-save..."
move_files
git_commit
git_push  # Commente cette ligne si tu ne veux pas pousser automatiquement
echo "Script terminé."
