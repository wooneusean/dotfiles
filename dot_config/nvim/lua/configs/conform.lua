local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sql = { "sqlfluff" },
    go = { "goimports", "gofumpt" },
    json = { "prettier" },
    jsonc = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },

  formatters = {
    sqlfluff = {
      -- Keep fixes even when unfixable violations remain; nvim-lint reports them.
      exit_codes = { 0, 1 },
    },

    prettier = {
      prepend_args = { "--trailing-comma", "none" },
    },
  },

  format_on_save = function(bufnr)
    if vim.bo[bufnr].filetype == "sql" then
      return { timeout_ms = 3000, lsp_format = "never" }
    end

    if vim.bo[bufnr].filetype ~= "go" then
      return
    end

    return { timeout_ms = 1000, lsp_format = "never" }
  end,
}

return options
