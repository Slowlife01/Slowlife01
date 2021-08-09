#!/bin/bash

set -eo pipefail
cd $GITHUB_WORKSPACE

echo "[LOG] Executing bash script"

git add .
git config user.name "SlowLife1661"
git config user.email "slowlife1165@gmail.com"

echo "[LOG] Committing"
git commit -m "chore: sync username" || true

echo "[LOG] Pushing"
git push origin "main"
