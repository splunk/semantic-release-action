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
name: Release
on:
  push:
    branches:
      - "main"
      - "develop"
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
  pull_request:
    branches:
      - "main"
      - "develop"
jobs:
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: "3.7"
      - name: Install actionlint
        run: |
          bash <(curl https://raw.githubusercontent.com/rhysd/actionlint/v1.6.23/scripts/download-actionlint.bash)
      - uses: pre-commit/action@v3.0.0

  build-release:
    name: Build and release action
    needs: pre-commit
    runs-on: ubuntu-latest
    steps:
      - 
        name: Checkout
        uses: actions/checkout@v3
        with:
          submodules: false
          persist-credentials: false
      - 
        name: Install yq
        run: sudo snap install yq
      - 
        name: Set up QEMU
        uses: docker/setup-qemu-action@v2
      - 
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      - 
        name: Login to GitHub Packages Docker Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GH_TOKEN }}
      - 
        name: Docker meta
        uses: docker/metadata-action@v4
        with:
          images: ghcr.io/splunk/splunk-release-test/splunk-release-test
          tags: |
            type=semver,pattern=v{{major}}.{{minor}}
            type=semver,pattern=v{{major}}
            type=semver,pattern=v{{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=semver,pattern={{major}}
            type=semver,pattern={{version}}
            type=ref,event=branch
            type=ref,event=pr
            type=sha
            type=sha,format=long
      - 
        name: Build and push action
        uses: docker/build-push-action@v3
        with:
          context: .
          push: true
          tags: ${{ steps.docker_action_meta.outputs.tags }}
          labels: ${{ steps.docker_action_meta.outputs.labels }}
          cache-to: type=inline
      - 
        name: Semantic release
        id: semantic
        uses: splunk/semantic-release-action@v1.2
        env:
          GITHUB_TOKEN: ${{ secrets.GH_TOKEN }}

  update-semver:
    name: Move Repository semver tags
    if: startsWith(github.ref, 'refs/tags/v')
    needs: build-release
    runs-on: ubuntu-latest
    steps:
      -  
        name: Checkout
        uses: actions/checkout@v3
      - 
        name: Update semver
        uses: haya14busa/action-update-semver@v1
        