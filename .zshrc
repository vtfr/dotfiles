export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Plugins
plugins=(git sudo)

# Oh My ZSH startup
source $ZSH/oh-my-zsh.sh

# User configuration
alias v="nvim"
alias m="tmux"

export EDITOR=nvim
