#!/usr/bin/env bash

SCRIPT_PATH="$(pwd)/scripts"
docker_script_name="01-docker_install.sh"
kind_script_name="02-kind_install.sh"
kubectl_scirpt_name="03-kubectl_install.sh"
helm_script_name="04-helm_install.sh"


chmod +x "$SCRIPT_PATH/$docker_script_name"
"$SCRIPT_PATH/$docker_script_name"

chmod +x "$SCRIPT_PATH/$kind_script_name"
"$SCRIPT_PATH/$kind_script_name"

chmod +x "$SCRIPT_PATH/$kubectl_scirpt_name"
"$SCRIPT_PATH/$kubectl_scirpt_name"

chmod +x "$SCRIPT_PATH/$helm_script_name"
"$SCRIPT_PATH/$helm_script_name"

echo "all utils instaling success"