# Instant prompt precedes shell initialization that does not request input.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
export EDITOR=nvim VISUAL=nvim SUDO_EDITOR=nvim FCEDIT=nvim GIT_EDITOR=nvim
export LANG=en_US.UTF-8
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
typeset -U path PATH
path=("$BUN_INSTALL/bin" "$HOME/.local/bin" $path)

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 14
zstyle ':omz:plugins:nvm' lazy yes
# Loading nvm before Neovim exposes npm to Mason and language servers.
zstyle ':omz:plugins:nvm' lazy-cmd nvim

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Completion definitions must be on fpath before Oh My Zsh runs compinit.
fpath=("${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src" $fpath)
plugins=(
  git gh z extract fzf sudo colored-man-pages aliases
  docker docker-compose kubectl npm python pip nvm
)
[[ $OSTYPE == linux* ]] && plugins+=(command-not-found)
plugins+=(
  zsh-completions
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 'Oh My Zsh is missing. Run scripts/bootstrap.sh from the chezmoi source directory.'
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
# SHARE_HISTORY appends commands as they run and imports other shells' history.
setopt EXTENDED_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS NO_BEEP

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
bindkey '^ ' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

(( $+commands[zoxide] )) && eval "$(zoxide init --cmd cd zsh)"
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
elif (( $+commands[fdfind] )); then
  alias fd=fdfind
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
fi
[[ -n ${FZF_DEFAULT_COMMAND:-} ]] && export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'

if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -lh --group-directories-first --icons --git'
  alias la='eza -lha --group-directories-first --icons --git'
  alias lt='eza --tree --level=2 --icons'
else
  alias ll='ls -lh'
  alias la='ls -lha'
fi
if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif (( $+commands[batcat] )); then
  alias cat='batcat --paging=never'
  alias bat=batcat
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
fi

alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias reload='exec zsh'
alias zshrc='chezmoi edit ~/.config/zsh/interactive.zsh'
alias vim=nvim vi=nvim v=nvim nv=nvim
alias vimdiff='nvim -d'
alias lzg=lazygit
alias tmc='clear && tmux clear-history'
alias p=pnpm
(( $+commands[zed] )) && alias code=zed

git_sweep() {
  local flag=-d
  [[ $1 == --force || $1 == -f ]] && flag=-D
  git fetch --prune || return
  local branch
  local -a branches
  branches=("${(@f)$(git branch -vv | awk '/: gone]/ {sub(/^[*+ ]+/, ""); print $1}')}")
  for branch in "${branches[@]}"; do
    [[ -n $branch ]] && git branch "$flag" -- "$branch"
  done
  return 0
}

# WG_DIR can be set in ~/.zshrc.local for a machine's WireGuard installation.
wg_all() {
  if [[ -z ${WG_DIR:-} || ! -d $WG_DIR ]]; then
    print -u2 'Set WG_DIR in ~/.zshrc.local to your WireGuard configuration directory.'
    return 1
  fi
  local f
  for f in "$WG_DIR"/*.conf(N); do
    sudo wg-quick "${1:-up}" "$f" || return
  done
}

[[ -r "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
# Work-specific settings and secrets stay outside the managed source.
if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
