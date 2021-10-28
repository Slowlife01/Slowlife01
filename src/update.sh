#!/bin/bash

cd $GITHUB_WORKSPACE

echo "[LOG] Executing bash script"

git add .
git config user.name "Slowlife01"
git config user.email "slowlife1165@gmail.com"

echo "[LOG] Committing"
git commit -m "update: sync username" || true

echo "[LOG] Pushing"
git push origin "main"

echo "[LOG] Successfully committed and pushed"
