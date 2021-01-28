#!/bin/bash

if [ -z "$1" ]; then
    echo "usage: ./swc.sh [options] <commit_num_starting_from_0>"
    echo "options:"
    echo "   -l   shows the commit list with commit number"
    exit 0
fi

list=0
while getopts "l" opt; do
    case "$opt" in
    l) list=1
    esac
done

if [ $list -eq "1" ]; then
    readarray -t logs < <((git log --pretty=format:'%C(Yellow)%h %Cgreen%aN %Creset%s %C(auto)' && echo ) | tac)
    for i in "${!logs[@]}"; do
        printf "%s   %s\n" "$i" "${logs[$i]}"
    done
    exit 0
fi

which_commit=$1
git_ids=git_ids.txt

[ ! -f "$git_ids" ] && (git log --pretty=format:"%h" && echo) | tac > $git_ids

commit_ids=($(cat $git_ids))
commit_to_detach=${commit_ids[$which_commit]}
echo detaching to $commit_to_detach
git checkout $commit_to_detach
