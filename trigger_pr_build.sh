#!/bin/bash

REPO=$1
BRANCH=$2
STASH=false

cd ${REPO}
CURRENT=`git branch --show-current`
echo "Current branch: ${CURRENT}"

if [[ `git status --porcelain` ]]; then
	# stash existing changes
	echo "Stashing existing changes on ${CURRENT}"
	STASH=true
	git stash push -m "WIP auto stashed via trigger_build script"
fi

git checkout ${BRANCH}
git commit --allow-empty -m "Trigger Build"
git push -u origin ${BRANCH}

git checkout ${CURRENT}

if [ ${STASH} == true ]; 
then
	echo "Popping stash"
	# In the future could remember the uuid of the stash and pop w/ that instead
	git stash pop stash@{0}
fi
