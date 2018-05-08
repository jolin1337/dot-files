#!/bin/sh

if test ! $(which brew); then
  echo "brew is not installed"
  echo 'if you are on mac, install it by executing: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
  exit
fi

# After the install, setup fzf
echo "\n\nRunning fzf install script..."
echo "=============================="
/usr/local/opt/fzf/install --all --no-bash --no-fish

# after hte install, install neovim python libraries
echo "\n\nRunning Neovim Python install"
echo "=============================="
pip2 install --user neovim
pip3 install --user neovim

# Change the default shell to zsh
zsh_path="$(which zsh)"
if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    echo "default shell changed to $zsh_path"
fi
