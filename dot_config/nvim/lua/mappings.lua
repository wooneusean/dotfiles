require "nvchad.mappings"

local map = vim.keymap.set

-- ── NvChad starter defaults ────────────────────────────────────
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- ── Save / quit ────────────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- ── Window navigation is already <C-h/j/k/l> in NvChad ─────────
-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window height +" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window height -" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window width +" })

-- ── Keep the cursor centred / selection intact ─────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centred" })
map("n", "n", "nzzzv", { desc = "Next search result, centred" })
map("n", "N", "Nzzzv", { desc = "Prev search result, centred" })
map("v", "<", "<gv", { desc = "Outdent, keep selection" })
map("v", ">", ">gv", { desc = "Indent, keep selection" })

-- Move the selected lines up/down
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- ── Clear search highlight ─────────────────────────────────────
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- ── Diagnostics ────────────────────────────────────────────────
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "LSP diagnostic in float" })
map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Prev diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

map("n", "<leader>gi", function()
  vim.lsp.buf.code_action {
    context = { only = { "source.organizeImports" }, diagnostics = {} },
    apply = true,
  }
end, { desc = "LSP organize imports" })

map("n", "<leader>gb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "git toggle inline blame" })

-- Recovers what the compact inline formatter leaves out: full commit message
-- and the hunk it belongs to.
map("n", "<leader>gB", function()
  require("gitsigns").blame_line { full = true }
end, { desc = "git blame line (full)" })
