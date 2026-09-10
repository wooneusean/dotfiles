require "nvchad.autocmds"

-- NvChad reads table specs; lazy resolves the function that merges our parsers.
vim.api.nvim_create_user_command("TSInstallAll", function()
  require("lazy").load { plugins = { "nvim-treesitter" } }
  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local opts = require("lazy.core.plugin").values(spec, "opts", false)
  require("nvim-treesitter").install(opts.ensure_installed)
end, { force = true })

-- Neovim resolves these three by the .json extension, which is the last rule it
-- tries, so they land on the json filetype -- the one filetype where jsonls
-- reports a comment as an error. All three carry comments in practice.
-- tsconfig.json and jsconfig.json need no entry; Neovim already patterns those.
vim.filetype.add {
  filename = {
    [".eslintrc.json"] = "jsonc",
    ["devcontainer.json"] = "jsonc",
    [".devcontainer.json"] = "jsonc",
  },
  pattern = {
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
}

-- vim.treesitter.start looks up a parser by filetype name, and jsonc has no
-- grammar of its own to find.
vim.treesitter.language.register("json", "jsonc")

-- gopls and jsonls both report folding ranges, which carry structure the
-- treesitter query only approximates: an import block or a comment group rather
-- than a run of sibling nodes. Scoped to the windows showing the buffer, so a
-- filetype whose server stays quiet keeps the treesitter expression.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspFolds", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client:supports_method "textDocument/foldingRange" then
      for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end
  end,
})
