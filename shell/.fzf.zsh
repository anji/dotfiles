# FZF Configuration

# FZF key bindings
# Ctrl+T - Paste the selected files and directories onto the command-line
# Ctrl+R - Paste the selected command from history onto the command-line
# Alt+C - cd into the selected directory

# Setup fzf key bindings and fuzzy completion
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# Default command using fd
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Options
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
  --preview-window=right:60%:wrap
  --bind=ctrl-u:preview-page-up,ctrl-d:preview-page-down
  --bind=ctrl-f:page-down,ctrl-b:page-up
'

# Ctrl+T options
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --bind 'ctrl-/:toggle-preview'
  --header 'CTRL-/ to toggle preview'
"

# Alt+C options
export FZF_ALT_C_OPTS="
  --preview 'exa --tree --level=2 --color=always {} | head -200'
  --bind 'ctrl-/:toggle-preview'
"

# Ctrl+R options
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:3:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'
  --header 'CTRL-Y to copy command into clipboard'
  --color header:italic
"

# Advanced customization of fzf options via _fzf_comprun function
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'exa --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"                          "$@" ;;
    ssh)          fzf --preview 'dig {}'                                    "$@" ;;
    *)            fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' "$@" ;;
  esac
}

# FZF Git integration functions
# These are defined here for easy sourcing

# Git branch checkout
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return
    
    local branches branch
    branches=$(git branch -a --color=always | grep -v '/HEAD\s' | sort) &&
    branch=$(echo "$branches" |
        fzf --ansi --tac --preview-window right:70% \
            --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200') &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Git commit browser
fzf-git-log() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}

# Git diff file browser
fzf-git-diff() {
    git diff --name-only "$@" |
    fzf --preview 'git diff --color=always {} | head -500' \
        --bind "enter:execute(nvim {})"
}

# Git stash browser
fzf-git-stash() {
    local stash
    stash=$(git stash list |
        fzf --preview 'git stash show -p $(cut -d: -f1 <<< {}) --color=always' \
            --bind 'enter:execute(git stash pop $(cut -d: -f1 <<< {}))')
}

# Interactive file search with preview
fzf-file-search() {
    local file
    file=$(fzf --query="$1" \
        --preview 'bat --color=always --style=numbers --line-range=:500 {}') &&
    echo "$file"
}

# Interactive process kill
fzf-kill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf --multi | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf --multi | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -${1:-9}
    fi
}

# Docker container selector
fzf-docker-container() {
    local container
    container=$(docker ps -a --format '{{.ID}} {{.Names}} {{.Status}}' |
        fzf --preview 'docker logs --tail 100 $(cut -d" " -f1 <<< {})' |
        cut -d" " -f1)
    echo "$container"
}

# Docker image selector
fzf-docker-image() {
    local image
    image=$(docker images --format '{{.Repository}}:{{.Tag}} {{.ID}} {{.Size}}' |
        fzf | cut -d" " -f2)
    echo "$image"
}

# Kubernetes pod selector
if command -v kubectl &> /dev/null; then
    fzf-k8s-pod() {
        local pod
        pod=$(kubectl get pods --all-namespaces --no-headers |
            fzf --preview 'kubectl logs -n {1} {2} --tail=100' |
            awk '{print $2}')
        echo "$pod"
    }
fi
