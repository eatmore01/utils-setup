#!/usr/bin/env bash

# Script for instaling a helm cli utils version 3 with official script provided helm

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

if chmod 700 get_helm.sh; then
    echo "===> Installing Helm..."
    
    if ./get_helm.sh; then
        echo "===> Helm installed successfully."
    else
        echo "===> Failed to install Helm."
        exit 1
    fi
else 
    echo "===> Error changing permissions for get_helm.sh."
    exit 1
fi