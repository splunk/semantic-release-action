#!/bin/bash
#   ########################################################################
#   Copyright 2021 Splunk Inc.
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

echo "dry_run: $dry_run"
echo "extra_plugins: $extra_plugins"

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
