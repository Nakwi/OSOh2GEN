#!/bin/bash

echo "Entrez le message de votre commit :"
read message

git_com () {

    git add .
    git commit -m "$message"
    git push
}

git_com
