-- Mirrors the structure of NvChad's nvconfig.lua:
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  theme_toggle = { "onedark", "one_light" }, -- <leader>th cycles these

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  cmp = {
    style = "default", -- default | flat_light | flat_dark | atom | atom_colored
    icons_left = true,
  },

  statusline = {
    theme = "default", -- default | vscode | vscode_colored | minimal
    separator_style = "default",
  },

  tabufline = {
    enabled = true,
    lazyload = false, -- show the buffer line on startup
  },
}

-- Dashboard on startup (the NvChad splash screen)
M.nvdash = {
  load_on_startup = true,
}

M.term = {
  float = {
    row = 0.1,
    col = 0.1,
    width = 0.8,
    height = 0.7,
  },
}

return M
