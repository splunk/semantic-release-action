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

# export GPG_TTY=`tty`
# echo $GPG_TTY
# export GIT_AUTHOR_NAME="srv-rr-github-token"
# export GIT_AUTHOR_EMAIL="4607705+srv-rr-github-token@users.noreply.github.com"
# export GIT_COMMITTER_NAME="srv-rr-github-token"
# export GIT_COMMITTER_EMAIL="4607705+srv-rr-github-token@users.noreply.github.com"
# echo "$gpg_private_key" | base64 --decode > /tmp/git_gpg.key
# chmod 600 /tmp/git_gpg.key
# passphrase_decoded=$(echo "$passphrase"|base64 --decode)
# gpg --batch --yes --import /tmp/git_gpg.key
#gpg --default-key E68AD642 --yes --pinentry-mode loopback --passphrase $passphrase_decoded --clearsign testfile.txt
#echo '/usr/bin/gpg --default-key E68AD642 --passphrase "$passphrase_decoded" --verbose --pinentry-mode loopback "$@"' > /tmp/gpg-with-passphrase && chmod +x /tmp/gpg-with-passphrase

# echo "========DEBUG=========="
# gpg --status-fd=2 -bsau "E68AD642"
# which gpg
# gpg --version
# cat ~/.gitconfig
# export GIT_TRACE=1
# gpg --list-secret-keys
#cat ~/.bashrc
#/usr/bin/gpg --no-tty --clearsign test.txt
#gpg --status-fd=2 -bsau "srv-rr-github-token"
#gpg -K --keyid-format SHORT
#git config -l | grep gpg
#echo "============DEBUG============="

#git config --global gpg.program "/tmp/gpg-with-passphrase"
#git config --global gpg.program $(which gpg)
# git config --global user.signingkey "E68AD642"
# git config --global commit.gpgsign true
# git config --global user.email 4607705+srv-rr-github-token@users.noreply.github.com
# git config --global user.name srv-rr-github-token

#git config --get user.signingkey
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
