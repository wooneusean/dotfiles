# Neovim

NvChad v2.5 configuration managed by chezmoi. Requires Neovim 0.12 or later.

Edit with `chezmoi edit ~/.config/nvim/lua/plugins/init.lua`, review with
`chezmoi diff`, then run `chezmoi apply`. Capture changes made directly under
this directory with `chezmoi re-add ~/.config/nvim` before committing.

Go files use goimports and gofumpt on save. Other formatters run through
`<leader>fm`. `<leader>gi` organizes imports; `<leader>gb` toggles inline Git
blame; `<leader>gB` opens full blame; `<leader>Rs` sends an HTTP request.

Use `:Lazy restore` for locked plugin versions and `:TSInstallAll` for parsers.
Use `:Mason` to manage external formatters and language servers. Setup and sync
instructions are in the README at `chezmoi source-path`.
