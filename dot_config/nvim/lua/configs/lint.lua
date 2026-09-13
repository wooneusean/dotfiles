local lint = require "lint"

-- No json entry, and none wanted: jsonls reports the parse errors and the
-- SchemaStore violations already, so jsonlint would only restate the parse
-- errors as a second diagnostic on the same line.
lint.linters_by_ft = {
  go = { "golangcilint" },
  sql = { "sqlfluff" },
}

-- PostgreSQL diagnostics use the buffer contents and the project's SQLFluff rules.
lint.linters.sqlfluff.args = { "lint", "--format=json", "--dialect=postgres", "-" }

local function lint_sql(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "sql" then
    return
  end

  -- Resolve .sqlfluff from this file's directory, even when Neovim was launched
  -- elsewhere. Pass cwd per invocation so different projects stay independent.
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h")
  vim.api.nvim_buf_call(bufnr, function()
    lint.try_lint("sqlfluff", { cwd = vim.fn.isdirectory(dir) == 1 and dir or nil })
  end)
end

local group = vim.api.nvim_create_augroup("UserLint", { clear = true })

-- Go runs on BufWritePost only. golangci-lint is whole-package analysis, not
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
  group = group,
  callback = function(args)
    if vim.bo[args.buf].filetype == "sql" then
      lint_sql(args.buf)
    else
      lint.try_lint()
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave" }, {
  group = group,
  callback = function(args)
    lint_sql(args.buf)
  end,
})

-- User FilePost can load this plugin after the first buffer was read.
vim.schedule(function()
  lint_sql(vim.api.nvim_get_current_buf())
end)
