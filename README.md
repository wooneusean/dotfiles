# Dotfiles

[chezmoi](https://www.chezmoi.io/)-managed configuration for macOS and Linux:

- Zsh with Oh My Zsh, Powerlevel10k, completions, autosuggestions, and syntax highlighting.
- tmux with mouse support, Vim-style pane navigation, and session persistence.
- Neovim with NvChad, language servers, formatters, Git integration, and HTTP tooling.

## Requirements

Install these tools before applying the configuration:

| Tool | Requirement |
| --- | --- |
| chezmoi and Git | Configuration management and plugin downloads |
| Zsh | 5.9 or later |
| tmux | Terminal multiplexer |
| Neovim | 0.12 or later |
| tree-sitter CLI | 0.26.1 or later, installed through a package manager or upstream release |
| C/C++ compiler | Builds Treesitter parsers |
| Node.js and npm | JavaScript-based language servers and Prettier |
| Go | Go language server and formatting tools |
| curl, tar, gzip, and unzip | Plugin and editor-tool installation |

Use a [Nerd Font](https://www.nerdfonts.com/) in the terminal to display prompt
and file icons. The shell sets `LANG=en_US.UTF-8`; enable that locale or override
`LANG` in `~/.zshrc.local` with a locale available on the system.

Optional shell tools include eza, bat (`batcat` on Ubuntu), fzf, fd (`fdfind` on
Ubuntu), zoxide, lazygit, pnpm, and Zed. An existing nvm installation under
`~/.nvm` loads on the first Node command or Neovim launch. Bun integration uses
`~/.bun` when installed.

## Installation

Fork this repository to maintain and publish your own configuration. Substitute
your fork's URL in the commands below. Public HTTPS cloning requires no GitHub
authentication; pushing requires authentication and write access to the repository.

Back up any existing files listed in [Configuration layout](#configuration-layout).
Initialize the source and install the shell and tmux plugins:

```sh
chezmoi init https://github.com/eusean-tg/dotfiles.git
sh "$(chezmoi source-path)/scripts/bootstrap.sh"
chezmoi diff
```

Review the diff, then install the configuration:

```sh
chezmoi apply
exec zsh -l
```

The bootstrap script clones missing Oh My Zsh, Powerlevel10k, zsh plugins, and
tmux plugins. It preserves existing Git clones and refuses to replace existing
non-Git directories. It does not install system packages or editor tools.
Complete the [Neovim setup](dot_config/nvim/README.md#setup) after applying.

To use SSH authentication, initialize with your repository's SSH URL. Set your
own Git identity before committing; repository-local settings are available
through `chezmoi git -- config user.name` and `chezmoi git -- config user.email`.
For GitHub email privacy, use the noreply address from your GitHub email settings.

To make zsh the login shell, run `chsh -s "$(command -v zsh)"`. The selected
binary must be listed in `/etc/shells`.

## Configuration layout

The source directory defaults to `~/.local/share/chezmoi`; `chezmoi source-path`
prints its location. Chezmoi translates the source filenames into these targets:

| Source | Installed path | Purpose |
| --- | --- | --- |
| `dot_zshrc` | `~/.zshrc` | Loads the interactive shell configuration |
| `dot_config/zsh/interactive.zsh` | `~/.config/zsh/interactive.zsh` | Plugins, history, aliases, and functions |
| `dot_zshenv` | `~/.zshenv` | User-local binaries and optional Cargo environment |
| `dot_zprofile.tmpl` | `~/.zprofile` | Homebrew executable paths on macOS and user-local paths |
| `dot_p10k.zsh` | `~/.p10k.zsh` | Compact one-line prompt |
| `dot_tmux.conf` | `~/.tmux.conf` | Pane navigation and session persistence |
| `dot_config/nvim` | `~/.config/nvim` | NvChad configuration and plugin lockfile |

Oh My Zsh loads from `~/.oh-my-zsh`, with third-party plugins under its
`custom/plugins` directory. Zsh plugins are installed as Git clones. tmux loads
plugins from `~/.tmux/plugins`; session restoration is enabled at server startup
and the save interval is 15 minutes.

## Customization

Edit managed files through chezmoi, then review and apply the changes:

```sh
chezmoi edit ~/.config/zsh/interactive.zsh
chezmoi diff
chezmoi apply
```

After editing an installed file directly, run `chezmoi re-add <path>` to capture
the change in the source. Use `chezmoi add <path>` to manage a new file.
Use `chezmoi edit` for templated files such as `~/.zprofile`; `re-add` does not
update templates.

`~/.zshrc.local` loads after the shell configuration and holds per-machine
settings such as environment variables, paths, and `WG_DIR` for the `wg_all`
helper. `~/.tmux.conf.local` loads before tmux plugin initialization. These
optional files are unmanaged. Keep credentials out of the source repository.

## Synchronization

Commit source changes and push them to your repository:

```sh
chezmoi git -- add -A
chezmoi git -- commit -m 'Adjust shell configuration'
chezmoi git -- push
```

On another installation:

```sh
chezmoi git -- pull --ff-only
chezmoi diff
chezmoi apply
```

Capture and commit local changes before pulling. If branches diverge, merge or
rebase in the source directory and resolve conflicts before applying.

Neovim's `lazy-lock.json` records plugin versions. After updating plugins, run
`chezmoi re-add ~/.config/nvim/lazy-lock.json` and commit the result. After pulling
and applying that lockfile elsewhere, run `:Lazy restore` in Neovim.

Shell and tmux plugin clones have their own version control. Update them with
their Git or plugin-manager commands; rerunning the bootstrap script preserves
existing clones.

## Recovery

Git history stores versions of managed configuration. To undo a committed
change, revert its commit in the source repository, review `chezmoi diff`, and
run `chezmoi apply`.

Restoring configuration from before chezmoi requires the backups made during
installation. Preserve subsequent edits before restoring those files. A later
`chezmoi apply` installs the managed source again. Shell history, editor caches,
and saved sessions are runtime data outside the managed configuration.
