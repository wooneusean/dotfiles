local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sql = { "pg_format" },
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
    pg_format = {
      prepend_args = {
        "-u",
        "1", -- lowercase keywords
        "-U",
        "1", -- type names lowercase
        "-f",
        "1", -- function names lowercase
        "-s",
        "2", -- 2-space indent
        "-w",
        "100", -- wrap lines past 100 chars
      },
    },

    prettier = {
      prepend_args = { "--trailing-comma", "none" },
    },
  },

  format_on_save = function(bufnr)
    if vim.bo[bufnr].filetype ~= "go" then
      return
    end

    return { timeout_ms = 1000, lsp_format = "never" }
  end,
}

return options
