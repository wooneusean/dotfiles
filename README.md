# Personal dotfiles

One chezmoi source for macOS and Linux: zsh, Powerlevel10k, tmux, and Neovim.
The Git origin is `git@github.com:eusean-tg/dotfiles.git`.
Each machine keeps its working source in `~/.local/share/chezmoi`.
The GitHub repository is public; machine-specific overrides and credentials
stay outside the source tree.

## Edit and sync

```sh
chezmoi edit ~/.config/zsh/interactive.zsh
chezmoi diff
chezmoi apply
chezmoi git -- add -A
chezmoi git -- commit -m 'Adjust shell configuration'
chezmoi git -- push
```

On the other machine:

```sh
chezmoi git -- pull --ff-only
chezmoi diff
chezmoi apply
```

Commit local source changes before pulling. If both machines have new commits,
resolve the Git conflict in the source directory before applying. Changes made
directly to installed files must be captured with `chezmoi re-add <path>` first.
Use `chezmoi edit` for templated files, including `~/.zprofile`.

Neovim's `lazy-lock.json` is managed. After a deliberate plugin update, run
`chezmoi re-add ~/.config/nvim/lazy-lock.json` and commit the result. On the other
machine, apply the config and run `:Lazy restore` to install the locked versions.

## Another machine

Install Git, chezmoi, zsh 5.9+, tmux, Neovim 0.12+, a C compiler, and
tree-sitter CLI 0.26.1+. Node/npm and Go are needed for the configured editor
tooling. Configure a GitHub SSH key on machines that will push changes.

Back up any existing shell, tmux, and Neovim configuration before applying.
Initialize the source, install plugins, and review the resulting diff:

```sh
chezmoi init git@github.com:eusean-tg/dotfiles.git
sh "$(chezmoi source-path)/scripts/bootstrap.sh"
chezmoi diff
chezmoi apply
exec zsh -l
```

For a machine without GitHub SSH authentication, use
`chezmoi init https://github.com/eusean-tg/dotfiles.git`. Public HTTPS cloning
needs no credentials; pushing still requires GitHub authentication.

Set zsh as the login shell if needed with `chsh -s "$(command -v zsh)"`.
The selected zsh binary must be listed in `/etc/shells`.

The bootstrap script clones missing Oh My Zsh, Powerlevel10k, zsh plugins, and
tmux plugins from their upstream repositories. It preserves existing clones.
Zsh plugins use `~/.oh-my-zsh/custom/plugins`; no Homebrew plugin paths are used.
Update existing third-party clones with their own Git or plugin-manager commands.

Use a Nerd Font for prompt and file icons. Optional shell tools are eza, bat
(batcat on Ubuntu), fzf, fd (fdfind on Ubuntu), zoxide, lazygit, and Zed.
The Oh My Zsh nvm plugin loads an existing nvm installation on the first Node
command or Neovim launch. Bun is enabled when installed under `~/.bun`.

In Neovim, run `:Lazy restore` and `:TSInstallAll`. Install external tools with
`:Mason`: lua-language-server, stylua, html-lsp, css-lsp, json-lsp, gopls,
goimports, gofumpt, prettier, and shfmt. SQL formatting uses `pg_format`
(pgFormatter). Go linting uses golangci-lint from the machine's PATH.

## Configuration ownership

| Source | Installed path / purpose |
| --- | --- |
| `dot_config/zsh/interactive.zsh` | Shared interactive shell settings |
| `dot_zshrc` | Loads the shared shell settings |
| `dot_zshenv` | User-local binaries and optional Cargo environment |
| `dot_zprofile.tmpl` | Homebrew executable PATH on macOS; user-local PATH on both OSes |
| `dot_p10k.zsh` | Compact one-line prompt |
| `dot_tmux.conf` | Mouse, pane navigation, session persistence |
| `dot_config/nvim` | NvChad configuration and plugin lockfile |

`~/.zshrc.local` holds machine-specific environment values and is not managed.
The Mac's AWS profile, OpenMarket development settings, and WireGuard directory
belong there. `~/.tmux.conf.local` is an optional unmanaged tmux override.
Credentials, histories, plugin installations, session data, and caches stay
outside the repository.

Neovim formats Go with goimports then gofumpt on save. Other languages format
on request with `<leader>fm`. The configuration includes Go/JSON LSP settings,
SQL formatting, Git blame, HTTP requests, sessions, relative numbers, persistent
undo, the dashboard, and shell/web/configuration parsers.

## Recovery

Migration snapshots are outside Git:

- Mac: `~/.local/state/dotfiles-migration/2026-09-10/mac-original.tar.gz`.
- Shared: `~/.local/state/dotfiles-migration/2026-09-10/shared-original.tar.gz`.
- The Mac also holds the shared snapshot and extracted copies of both.

Each machine's migration directory contains its rollback instructions. Archive
the managed source and any later edits before restoring a snapshot. Shell
history, tmux sessions, and Neovim data are separate from these config archives.

The Mac and shared retain the LAN repository as the `lan` remote for explicit
backup pushes (`chezmoi git -- push lan main`). Normal pushes and pulls use GitHub.

Shared's Neovim 0.12.4 lives in `~/.local/opt/nvim-0.12.4`, exposed through
`~/.local/bin/nvim`. Its distribution Neovim remains at `/usr/bin/nvim`.
