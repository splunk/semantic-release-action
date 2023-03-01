#!/bin/bash
#   ########################################################################
#   Copyright 2023 Splunk Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#   ######################################################################## 
dry_run=$1
extra_plugins=$2
gpg_private_key=$3
passphrase=$4
echo "dry_run: $dry_run"
echo "extra_plugins: $extra_plugins"

export GIT_AUTHOR_NAME="srv-rr-github-token"
export GIT_AUTHOR_EMAIL="srv-rr-github-token@splunk.com"
export GIT_COMMITTER_NAME="srv-rr-github-token"
export GIT_COMMITTER_EMAIL="srv-rr-github-token@splunk.com"
echo "$gpg_private_key" | base64 --decode > git_gpg.key
passphrase_decoded=$(echo "$passphrase"|base64 --decode)
#chmod 600 /tmp/git_gpg.key
gpg --batch --yes --import git_gpg.key
echo '/usr/bin/gpg2 --passphrase "$passphrase_decoded" --batch --no-tty "$@"' > /tmp/gpg-with-passphrase && chmod +x /tmp/gpg-with-passphrase
git config --global gpg.program "/tmp/gpg-with-passphrase"
gpg --list-secret-keys

git config --global user.signingkey "srv-rr-github-token"
git config --global commit.gpgsign true
git config --global user.email srv-rr-github-token@splunk.com
git config --global user.name srv-rr-github-token

# adding trusted dir: https://github.com/actions/runner-images/issues/6775
git config --global --add safe.directory /github/workspace

install_command="npm install --no-package-lock --legacy-peer-deps --save false -D @semantic-release/changelog @semantic-release/git @semantic-release/exec"
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
