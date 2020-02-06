HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch notify COMPLETE_ALIASES
bindkey -e
zstyle :compinstall filename '/home/alexleekt/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
ttyctl -f

autoload -Uz compinit && compinit

source /usr/share/autojump/autojump.zsh

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

powerline-daemon -q
# . /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

POWERLEVEL9K_MODE='awesome-fontconfig'

source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

alias l='colorls'
