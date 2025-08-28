#!/bin/bash

script_directory=scripts

execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}


execute_script "package.sh"
execute_script "docker.sh"
execute_script "helm.sh"
execute_script "kubectl.sh"
execute_script "talosctl.sh"
execute_script "zsh.sh"
execute_script "go.sh"
execute_script "yazi.sh"