#!/bin/bash

dry_run=$1
extra_plugins=$2

echo "dry_run: $dry_run"
echo "extra_plugins: $extra_plugins"
echo "ls"
ls -la

install_command="npm install --legacy-peer-deps -D @semantic-release/changelog @semantic-release/git @semantic-release/exec"
if [[ ! -z "$extra_plugins" ]]
then
    while IFS= read -r line
    do
    if [ ! -z "$line" ];then
        install_command="$install_command $(echo -e "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    fi
    done <<< "$extra_plugins"
fi
$install_command

if [[ "$dry_run" == true ]]
then
    echo "Running dry-run Semantic Release"
    npx semantic-release@20 --dry-run
else 
    echo "Running Semantic Release"
    npx semantic-release@20
fi

cat $GITHUB_OUTPUT