#!/usr/bin/env bash

command_exists() {
    type "$1" > /dev/null 2>&1
}

package_manager=apt-get
# only perform macOS-specific install
if [ "$(uname)" == "Darwin" ]; then
  package_manager=brew
fi
if hash sudo 2>/dev/null; then
  package_manager="sudo $package_manager"
fi

echo "Installing dotfiles."

echo "Initializing submodule(s)"
git submodule update --init --recursive

echo "Installing packages"
while read -r line; do
  $package_manager install -y $line
done < "install/packages.txt"

source install/zsh-autocompletion.sh
source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
  source install/brew.sh
  source install/osx.sh
fi

echo "create vim directories"
mkdir -p ~/.vim-tmp
nvim -c ":PlugInstall" -c ":q" -c ":q"

echo "Done. Reload your terminal."
