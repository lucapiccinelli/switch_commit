#!/bin/bash

if [ -z "$1" ]; then
    echo "usage: ./swc.sh <commit_num_starting_from_0>"
    exit 0
fi

which_commit=$1
git_ids=git_ids.txt

[ ! -f "$git_ids" ] && (git log --pretty=format:"%h" && echo) | tac > $git_ids

commit_ids=($(cat $git_ids))
commit_to_detach=${commit_ids[$which_commit]}
echo detaching to $commit_to_detach
git checkout $commit_to_detach
