# Dotfiles

Welcome to my world. This is a collection of vim, tmux, and zsh configurations.

## Contents

+ [Initial Setup and Installation](#initial-setup-and-installation)
+ [Tools Setup](#tool-setup)

## Initial Setup and Installation

### Requirements

* docker
* docker-compose (optional)

### Installation

Then, clone the dotfiles repository anywhere on your computer. The docker container will create mount-points to your file system for the required folders

```bash
➜ git clone https://github.com/jolin1337/dotfiles.git ~/.dotfiles
➜ cd ~/.dotfiles
➜ docker-compose build local
```

The build will compile all required packages and programs for your docker container. Settings for each program can be added into a config folder (could be done after build).

## Tool Setup

The tools installed are all configurable accordingly with their instructions on the official releases. The tools currently included are:

* neovim
* oh-my-zsh
* fzf
* docker and docker-compose cli
* tmux

Programming languages that are also included are:

* python
* nodejs
* go-lang

### Tmux Configuration

Tmux is a terminal multiplexor which lets you create windows and splits in the terminal that you can attach and detach from. I use it to keep multiple projects open in separate windows and to create an IDE-like environment to work in where I can have my code open in vim/neovim and a shell open to run tests/scripts. Tmux is configured in [~/.tmux.conf](tmux/tmux.conf.symlink), and in [tmux/theme.sh](tmux/theme.sh), which defines the colors used, the layout of the tmux bar, and what what will be displayed, including the time and date, open windows, tmux session name, computer name, and current iTunes song playing. If not running on macOS, this configuration should be removed.
