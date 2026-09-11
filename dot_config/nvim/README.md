# Neovim

NvChad v2.5 configuration managed by chezmoi. Requires Neovim 0.12 or later and
uses the `main` branch of nvim-treesitter. Plugin revisions are recorded in
`lazy-lock.json`.

## Setup

Apply the dotfiles configuration and install the prerequisites in the
[installation guide](https://github.com/eusean-tg/dotfiles#installation).
Open Neovim and run:

```vim
:Lazy restore
:TSInstallAll
:MasonInstall lua-language-server stylua html-lsp css-lsp json-lsp gopls goimports gofumpt prettier shfmt
```

`:Lazy restore` installs the locked plugin revisions. `:TSInstallAll` installs
the parsers listed in `lua/plugins/init.lua`; parser compilation requires the
tree-sitter CLI and a C/C++ compiler. Mason installs external language servers
and formatters. Use `:Mason` to inspect their installation status.

Install pgFormatter (`pg_format`) for SQL formatting and golangci-lint for Go
linting through the system package manager or their upstream installers. These
executables must be on Neovim's PATH.

## Editing behavior

Go files run goimports followed by gofumpt on save. Other configured filetypes
format on request with `<leader>fm`. JSON and JSONC use Prettier with trailing
commas disabled. SQL uses pgFormatter with lowercase keywords and two-space
indentation.

Language-server configuration includes Go, JSON, HTML, and CSS. JSON schemas
come from SchemaStore. Go linting runs golangci-lint after writes. Treesitter
supplies folds; an attached language server with folding support supplies its
folding ranges. Files open with folds expanded.

The UI uses the onedark theme, relative line numbers, persistent undo, a
dashboard, automatic session management, inline Git blame, and a scrollbar.
`<leader>` is Space.

| Mapping | Action |
| --- | --- |
| `<leader>fm` | Format the buffer |
| `<leader>gi` | Organize imports through the language server |
| `<leader>gb` | Toggle inline Git blame |
| `<leader>gB` | Show full blame information for the line |
| `<leader>ld` | Show a diagnostic popup |
| `<leader>Rs` | Send an HTTP request from an HTTP/REST buffer |
| `<leader>s` in visual mode | Start a substitution restricted by the visual selection |
| `<C-s>` | Save the file |
| `<C-h/j/k/l>` | Move between windows |
| `<C-Up/Down/Left/Right>` | Resize the window |
| `jk` in insert mode | Leave insert mode |

### Substitution in a visual selection

Select text and press `<leader>s` to pre-fill `:'<,'>s/\%V`. Type `a/b/g` and
press Enter to replace selected occurrences of `a` with `b`:

```vim
:'<,'>s/\%Va/b/g
```

The `'<,'>` range addresses whole lines. The `\%V` pattern requires a match to
start inside the visual selection and works with character, line, and block
selections. For a multi-character literal such as `foo`, use `\%Vfo\%Vo` to
require its final character to be inside the selection too. See `:help /\%V`.

## Configuration files

| File | Purpose |
| --- | --- |
| `lua/plugins/init.lua` | Plugin declarations and Treesitter parser list |
| `lua/configs/conform.lua` | Formatters and Go format-on-save policy |
| `lua/configs/lspconfig.lua` | Language servers and JSON schemas |
| `lua/configs/lint.lua` | Go linting |
| `lua/mappings.lua` | Key bindings |
| `lua/options.lua` | Editing and display options |
| `lua/autocmds.lua` | Parser installation command, JSONC detection, and LSP folds |
| `lua/chadrc.lua` | Theme, dashboard, and UI settings |
| `lazy-lock.json` | Plugin revision lockfile |

Edit with `chezmoi edit ~/.config/nvim/lua/plugins/init.lua`, review with
`chezmoi diff`, and run `chezmoi apply`. Capture direct edits to managed files
with `chezmoi re-add ~/.config/nvim` before committing. Register additional
configuration files with `chezmoi add <path>`.

After a plugin update, capture the lockfile with
`chezmoi re-add ~/.config/nvim/lazy-lock.json` and commit it. Other installations
can pull, apply, and run `:Lazy restore` to use those revisions.
