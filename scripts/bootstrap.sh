#!/bin/sh
set -eu

command -v git >/dev/null
dotfiles_zsh_dir=${ZSH:-"$HOME/.oh-my-zsh"}
dotfiles_custom_dir=${ZSH_CUSTOM:-"$dotfiles_zsh_dir/custom"}

clone_missing() {
  if [ -d "$2/.git" ]; then
    return
  fi
  if [ -e "$2" ]; then
    printf 'Refusing to replace existing non-Git directory: %s\n' "$2" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$2")"
  git clone --depth=1 "https://github.com/$1.git" "$2"
}

clone_missing ohmyzsh/ohmyzsh "$dotfiles_zsh_dir"
clone_missing romkatv/powerlevel10k "$dotfiles_custom_dir/themes/powerlevel10k"
for dotfiles_plugin in zsh-completions zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting; do
  clone_missing "zsh-users/$dotfiles_plugin" "$dotfiles_custom_dir/plugins/$dotfiles_plugin"
done
for dotfiles_plugin in tpm tmux-resurrect tmux-continuum; do
  clone_missing "tmux-plugins/$dotfiles_plugin" "$HOME/.tmux/plugins/$dotfiles_plugin"
done
printf 'Shell and tmux plugin directories are ready.\n'
