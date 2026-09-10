local lint = require "lint"

-- No json entry, and none wanted: jsonls reports the parse errors and the
-- SchemaStore violations already, so jsonlint would only restate the parse
-- errors as a second diagnostic on the same line.
lint.linters_by_ft = {
  go = { "golangcilint" },
}

-- BufWritePost only, deliberately. golangci-lint is whole-package analysis, not
-- a per-file linter, so it costs seconds on a large module -- running it on
-- InsertLeave or TextChanged would queue redundant passes faster than they
-- finish. nvim-lint spawns it asynchronously, so the write itself never blocks.
--
-- nvim-lint's bundled golangcilint linter handles the rest: it version-detects
-- the binary (v2 needs --output.json.path=stdout instead of v1's --out-format,
-- plus --path-mode=abs from 2.1.0 on) and passes the file's parent directory
-- when a go.mod is present, falling back to the file path when there isn't one.
-- That means a repo's own .golangci.yml is picked up, so diagnostics here match
-- what CI reports.
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
