#!/bin/bash

set -eo pipefail

cd $GITHUB_WORKSPACE

REPO="https://github.com/SlowLife1661/SlowLife1661.git"
BRANCH_OR_TAG=`awk -F/ '{print $2}' <<< $GITHUB_REF`
CURRENT_BRANCH=`awk -F/ '{print $NF}' <<< $GITHUB_REF`

if [ "$BRANCH_OR_TAG" == "heads" ]; then
  SOURCE_TYPE="branch"
else
  SOURCE_TYPE="tag"
fi

TARGET_BRANCH="main"

if [ ! "$(git ls-remote origin $TARGET_BRANCH)" ]; then
	echo "::[notice] # Branch $TARGET_BRANCH not found, exiting action"
	exit
fi

echo "::[notice] # Commit and push"
git add .
git config user.name "SlowLife1661"
git config user.email "slowlife1165@gmail.com"
git commit -m "chore: sync username" || true
git push origin $TARGET_BRANCH