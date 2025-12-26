# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme - Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-My-Zsh plugins
plugins=(
    git
    docker
    docker-compose
    kubectl
    terraform
    aws
    colored-man-pages
    command-not-found
    sudo
    extract
    z
    fzf
    history
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# User Configuration
# ============================================================================

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Enable zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# ============================================================================
# Environment Variables
# ============================================================================

# Default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 40% --layout=reverse --border
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
'

# Bat (cat replacement) theme
export BAT_THEME="Dracula"

# ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# ============================================================================
# Key Bindings
# ============================================================================

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Edit command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# ============================================================================
# Aliases
# ============================================================================

# Load aliases from separate file
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# ============================================================================
# Functions
# ============================================================================

# Load functions from separate file
if [ -f ~/.functions ]; then
    source ~/.functions
fi

# ============================================================================
# FZF Integration
# ============================================================================

# Source FZF if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF Git integration
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return
    
    local branches branch
    branches=$(git branch -a --color=always | grep -v '/HEAD\s' | sort) &&
    branch=$(echo "$branches" | fzf --ansi --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200') &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
zle -N fzf-git-branch
bindkey '^G' fzf-git-branch

# FZF file search with preview
fzf-file-widget() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}') && echo "$file"
}

# ============================================================================
# Auto-suggestions Configuration
# ============================================================================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ============================================================================
# Zellij Auto-start (optional - comment out if not desired)
# ============================================================================

# Auto-start Zellij if not already in a Zellij session
# if [[ -z "$ZELLIJ" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
#     if command -v zellij >/dev/null 2>&1; then
#         zellij attach -c default
#     fi
# fi

# ============================================================================
# Powerlevel10k Configuration
# ============================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Additional Integrations
# ============================================================================

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Direnv (if installed)
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# ============================================================================
# Welcome Message
# ============================================================================

# Display a welcome message with useful info
if command -v neofetch >/dev/null 2>&1; then
    # neofetch
fi
