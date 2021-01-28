#!/bin/bash

function show_help {
    echo "usage: ./swc.sh [options] <commit_num_starting_from_0>"
    echo "options:"
    echo "   -l   shows the commit list with commit number. Can be followed by branch name. Example \"swh -l master\""
    echo "   -h   shows this help"
}

if [ -z "$1" ]; then
    show_help
    exit 0
fi

list=0
help=0
while getopts "lh" opt; do
    case "$opt" in
    l) list=1;;
    h) help=1;;
    esac
done

if [ $help -eq "1" ]; then
    show_help
    exit 0
fi

if [ $list -eq "1" ]; then
    readarray -t logs < <((git log $2 --pretty=format:'%C(Yellow)%h %Cgreen%aN %Creset%s %C(auto)' && echo ) | tac)
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
