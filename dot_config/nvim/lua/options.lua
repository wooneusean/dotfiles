require "nvchad.options"

local o = vim.o

-- ── Line numbers & cursor ──────────────────────────────────────
o.relativenumber = true -- relative numbers make 5j / 12k natural
o.cursorlineopt = "both" -- highlight the line AND the number

-- ── Scrolling / view ───────────────────────────────────────────
o.scrolloff = 8 -- keep 8 lines of context above/below
o.sidescrolloff = 8
o.wrap = false

-- ── Indentation (NvChad sets 2-space default; these round it out) ─
o.smartindent = true
o.breakindent = true

-- ── Search ─────────────────────────────────────────────────────
o.ignorecase = true
o.smartcase = true -- a capital letter in the pattern makes it case-sensitive
o.inccommand = "split" -- live preview of :%s///

-- ── Persistent undo: undo history survives closing the file ────
o.undofile = true
o.undolevels = 10000

-- ── Splits open where you expect ───────────────────────────────
o.splitright = true
o.splitbelow = true

-- ── Misc ───────────────────────────────────────────────────────
o.confirm = true -- ask to save instead of failing on :q
o.updatetime = 250 -- faster CursorHold (gitsigns, diagnostics)
o.timeoutlen = 400
o.termguicolors = true

-- Show whitespace that matters
o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Treesitter supplies folds until an LSP with folding support attaches.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
o.foldlevel = 99
o.foldlevelstart = 99
vim.opt.fillchars:append { fold = " " }
