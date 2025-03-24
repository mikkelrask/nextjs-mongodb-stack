#!/bin/sh
set -e

echo "Cloning repo ⏬"

if [ -n "$GIT_USER" ] && [ -n "$GIT_PASS" ]; then
    echo "Using authenticated Git clone 🫡"
    REPO_PATH=$(echo ${REPO_URL} | sed 's/https:\/\/github.com\///')
    git clone https://${GIT_USER}:${GIT_PASS}@github.com/${REPO_PATH} app
else
    echo "Cloning anonymously 😶‍🌫️ "
    git clone ${REPO_URL} app
fi
