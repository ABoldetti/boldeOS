# Point to the system-wide immutable Oh My Zsh installation
export ZSH="/usr/share/oh-my-zsh"

# Store cache and auto-update files in the user's writable home directory
export ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR"
DISABLE_AUTO_UPDATE="true"

# Theme & Plugins
ZSH_THEME="robbyrussell"
plugins=(git sudo)

source $ZSH/oh-my-zsh.sh