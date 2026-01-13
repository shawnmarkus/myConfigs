local g = vim.g
local o = vim.o

-- Colorscheme
g.gruvbox_material_background='hard'
g.gruvbox_contrast_dark='hard'

vim.cmd [[
colorscheme gruvbox-material
]]

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


-- Telescope setup
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  local actions_ok, actions = pcall(require, "telescope.actions")
  if actions_ok then
    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          preview_width = 0.55,
        },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
      },
      pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
    })
    
    pcall(require("telescope").load_extension, "fzf")
  end
end


require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },

  renderer = {
    highlight_opened_files = "name",
    root_folder_label = false,
    icons = {
      show = {
        file = true,
        folder = true,
        git = true,
      },
    },
  },

  update_focused_file = {
    enable = true,
    update_root = false,
  },

  git = {
    enable = true,
  },

  filters = {
    dotfiles = false,
  },
})


require("gitsigns").setup({
  current_line_blame = true, -- enable hover blame
  current_line_blame_opts = {
    delay = 200,            -- 👈 200 ms delay
    virt_text = true,
    virt_text_pos = "eol",  -- show at end of line
    ignore_whitespace = false,
  },
})
