#!/bin/bash

set -eo pipefail
cd $GITHUB_WORKSPACE

echo "::[notice] # Commit and push"

git add .
git config user.name "SlowLife1661"
git config user.email "slowlife1165@gmail.com"
git commit -m "chore: sync username" || true
git push origin "main"