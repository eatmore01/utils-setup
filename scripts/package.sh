#!/bin/bash



# lib section
## paste here for opportunity run this is script separate

if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

set -e

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


install_package() {
  if sudo dpkg -l | grep -q -w "$1" ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    echo -e "${NOTE} Installing $1 ..."
    sudo apt-get install -y "$1" 2>&1 | tee -a "$LOG"
    if sudo dpkg -l | grep -q -w "$1" ; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry, I have tried :("
      exit 1
    fi
  fi
}

uninstall_package() {
  if sudo dpkg -l | grep -q -w "^ii  $1" ; then
    echo -e "${NOTE} Uninstalling $1 ..."

    sudo apt-get autoremove -y "$1" >> "$LOG" 2>&1

    if ! dpkg -l | grep -q -w "^ii  $1" ; then
      echo -e "\e[1A\e[K${OK} $1 was uninstalled."
    else
      echo -e "\e[1A\e[K${ERROR} $1 failed to uninstall. Please check the uninstall.log."
      exit 1
    fi
  fi
}


log() {
    printf "\n%s - %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$1"
}
# ---


package=( 
  wget
  net-tools
  dns-utils
  file
  ffmpeg
  7zip
  jq
  poppler-utils
  fd-find
  ripgrep
  fzf
  zoxide
  imagemagick
  curl
  gpg
  apt-transport-https
  ca-certificates
  iotop
  htop
)


PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1


LOG="Install-Logs/install-$(date +%d-%H%M%S)_required-pkgs.log"

log "${NOTE} Installing required packages... " 

for PKG1 in "${package[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ "$PKG1" == "code" ];then
    cp -r cfg/vscode-settings.json ~/.config/Code/User/settings.json
  fi
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done
