require("nvchad.configs.lspconfig").defaults()

-- read :h vim.lsp.config for changing options of lsp servers

-- Must precede vim.lsp.enable below. nvim-lspconfig loads on NvChad's
-- "User FilePost" event, which fires after the buffer is already open, so
-- vim.lsp.enable can attach a client synchronously using whatever config is
-- registered at that instant. Registering settings afterwards means the first
-- Go file of a session silently starts a gopls with none of them applied.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      -- staticcheck stays off here on purpose: golangci-lint bundles it (v2
      -- enables it by default), so turning it on too reports every finding
      -- twice -- once from gopls, once from nvim-lint.
      staticcheck = false,

      -- Cheap analyses gopls runs as you type, chosen to not overlap with
      -- golangci-lint's default set (errcheck, govet, ineffassign, unused).
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },

      completeUnimported = true,
      usePlaceholders = true,
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      -- SchemaStore.nvim vendors the schemastore.org catalog as a Lua table.
      -- jsonls itself bundles schemas for a handful of VS Code files only, so
      -- without the catalog a package.json, tsconfig.json or .eslintrc.json
      -- resolves to no schema at all: no key completion, nothing validated.
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

local servers = { "html", "cssls", "gopls", "jsonls" }
vim.lsp.enable(servers)
