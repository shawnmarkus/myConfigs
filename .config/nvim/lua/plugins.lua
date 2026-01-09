vim.pack.add({
  -- Colorscheme
  "https://github.com/sainnhe/gruvbox-material",

  -- Navigation integration with tmux
  "https://github.com/christoomey/vim-tmux-navigator",

  -- Comments
  "https://github.com/preservim/nerdcommenter",

  -- Git
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",

  -- Fuzzy finder
  "https://github.com/nvim-mini/mini.pick",

  -- Statusline
  "https://github.com/nvim-lualine/lualine.nvim",

  -- Markdown
  "https://github.com/iamcco/markdown-preview.nvim",

  -- Completion (dependencies first)
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/saghen/blink.cmp",


  -- Required plugins
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",


  -- Auto completion and ai suggestion
  "https://github.com/yetone/avante.nvim"
})

local function find_plugin_dir(plugin_name)
  local data_dir = vim.fn.stdpath('data')
  local pattern = data_dir .. '/pack/pack/*/start/' .. plugin_name
  local dirs = vim.fn.glob(pattern, false, true)
  if #dirs > 0 then
    return dirs[1]
  end
  return nil
end

-- Install markdown-preview.nvim if needed
local function install_markdown_preview()
  local mkdp_dir = find_plugin_dir('markdown-preview.nvim')
  if mkdp_dir and vim.fn.isdirectory(mkdp_dir) == 1 then
    -- Check if already installed by looking for app directory
    local app_dir = mkdp_dir .. '/app'
    if vim.fn.isdirectory(app_dir) == 0 then
      vim.notify("Installing markdown-preview.nvim...", vim.log.levels.INFO)
      -- Use vim.schedule to ensure plugin is loaded
      vim.schedule(function()
        if vim.fn.exists('*mkdp#util#install') == 1 then
          vim.fn["mkdp#util#install"]()
        end
      end)
    end
  end
end

-- Run build commands after a short delay to ensure plugins are loaded
vim.schedule(function()
  install_markdown_preview()
end)

-- Handle build commands on PackChanged event
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function()
    install_markdown_preview()
  end,
})
