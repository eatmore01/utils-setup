#!/bin/bash


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




zsh=(
    zsh
    zplug 
)


PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1


LOG="Install-Logs/install-$(date +%d-%H%M%S)_zsh.log"

COUNTER=1
while [ -f "$LOG" ]; do
  LOG="Install-Logs/install-$(date +%d-%H%M%S)_${COUNTER}_zsh.log"
  ((COUNTER++))
done

printf "${NOTE} Installing core zsh packages...${RESET}\n"
for ZSHP in "${zsh[@]}"; do
  install_package "$ZSHP" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
     echo -e "\e[1A\e[K${ERROR} - $ZSHP Package installation failed, Please check the installation logs"
  fi
done

printf "\n"


if command -v zsh >/dev/null; then
  printf "${NOTE} Installing Oh My Zsh and plugins...\n"
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
  		sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
	else
		echo "Directory .oh-my-zsh already exists. Skipping re-installation." 2>&1 | tee -a "$LOG"
	fi
	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
	else
    	echo "Directory zsh-autosuggestions already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
	else
    	echo "Directory zsh-syntax-highlighting already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
    	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting || true
	else
    	echo "Directory fast-syntax-highlighting already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi
	
	if [ -f "$HOME/.zshrc" ]; then
    	cp -b "$HOME/.zshrc" "$HOME/.zshrc.backup" || true
	fi

    cat >> ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"
export KUBECONFIGS="?"
export TERM=xterm-256color

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

ENABLE_CORRECTION="true"

alias l="ls -la"

alias d='docker'
alias dc='docker compose'

alias k='kubectl'
alias h='helm'
alias ktx="kubectx"

alias tf='terraform'
alias tg="terragrunt"

alias ks="kubeswitches"

alias gen_tf_doc="terraform-docs markdown table --output-file README.md --output-mode inject"
alias hd="helm-docs"
alias v="vault"

# git alias
alias commit="git add . && git commit -am"
alias push="git push origin"
alias pullreb="git pull origin --rebase"

alias sshconfig="vim ~/.ssh/config"
alias zshconfig="vim ~/.zshrc"
EOF

  printf "${NOTE} Changing default shell to zsh...\n"

	while ! chsh -s $(which zsh); do
    echo "${ERROR} Authentication failed. Please enter the correct password."
    sleep 1	
	done
	printf "\n"
	printf "${NOTE} Shell changed successfully to zsh.\n" 2>&1 | tee -a "$LOG"

fi

clear
