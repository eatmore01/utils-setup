#!/bin/bash


GO_VERSION=1.25.0

wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
