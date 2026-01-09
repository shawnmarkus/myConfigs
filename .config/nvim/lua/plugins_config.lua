local g = vim.g
local o = vim.o

-- Colorscheme
g.gruvbox_material_background='hard'
g.gruvbox_contrast_dark='hard'

vim.cmd [[
colorscheme gruvbox-material
]]

-- Fuzzy finder (mini.pick)
require('mini.pick').setup({})

-- Git modifications sign
require('gitsigns').setup()

-- Statusline
require('lualine').setup()

-- Markdown Preview
g.mkdp_auto_start = 0

-- Completion (blink.cmp)
require('blink.cmp').setup({
  keymap = { preset = 'default' },

  completion = {
    documentation = { auto_show = true },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = {
    implementation = "lua",
  },
})

require('avante').setup({
  provider = "claude",
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-sonnet-4-20250514",
      timeout = 30000,
      extra_request_body = {
        temperature = 0.0,
        max_tokens = 4096,
      },
    },
  },
})

