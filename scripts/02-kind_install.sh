#!/usr/bin/env bash

# Script for instaling a kind utils with version 0.26.0 ( last version on 28/12/2024 )

VERSION=v0.26.0

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$VERSION/kind-linux-amd64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/$VERSION/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind