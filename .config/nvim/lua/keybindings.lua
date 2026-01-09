local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map('n', '<leader>qq', ':bw!<CR>')
map('n', '<leader>h', ':noh<CR>')

-- mini.pick stuff
local MiniPick = require('mini.pick')
map('n', '<leader>f', function() MiniPick.builtin.files({ tool = 'git' }) end)
map('n', '<leader>/', function() MiniPick.builtin.grep_live() end)
map('n', '<leader>b', function() MiniPick.builtin.buffers() end)
map('n', '<leader>j', function() MiniPick.builtin.jumps() end)

-- git branches
local function parse_git_lines(output)
  local lines = {}
  for line in output:gmatch('[^\n]+') do
    table.insert(lines, line)
  end
  return lines
end

map('n', '<leader>gb', function()
  MiniPick.start({
    source = {
      name = 'Git Branches',
      items = function()
        local output = vim.fn.system('git branch --format="%(refname:short)"')
        return parse_git_lines(output)
      end,
      choose = function(item)
        local result = vim.fn.system('git checkout ' .. vim.fn.shellescape(item))
        if vim.v.shell_error == 0 then
          vim.cmd('checktime')
        else
          vim.notify('Git checkout failed: ' .. result, vim.log.levels.ERROR)
        end
      end,
    }
  })
end)

-- git status
map('n', '<leader>gs', function()
  MiniPick.start({
    source = {
      name = 'Git Status',
      items = function()
        local output = vim.fn.system('git status --porcelain')
        local lines = parse_git_lines(output)
        local files = {}
        for _, line in ipairs(lines) do
          local file = line:match('%S+%s+(.+)')
          if file then
            table.insert(files, file)
          end
        end
        return files
      end,
      choose = function(item)
        vim.cmd('edit ' .. item)
      end,
    }
  })
end)

-- lsp symbols
map('n', '<leader>ls', vim.lsp.buf.document_symbol)
map('n', '<leader>lw', vim.lsp.buf.workspace_symbol)

-- lsp diagnostics
map('n', '<leader>le', function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify('No diagnostics found', vim.log.levels.INFO)
    return
  end

  local severity_names = {
    [vim.diagnostic.severity.ERROR] = 'E',
    [vim.diagnostic.severity.WARN] = 'W',
    [vim.diagnostic.severity.INFO] = 'I',
    [vim.diagnostic.severity.HINT] = 'H',
  }

  local items = {}
  for _, diag in ipairs(diagnostics) do
    local severity = severity_names[diag.severity] or '?'
    local line = diag.lnum + 1
    local message = diag.message:gsub('\n', ' '):gsub('\r', '')
    local display_text = string.format('[%s] %d: %s', severity, line, message)

    table.insert(items, {
      text = display_text,
      diag = diag,
    })
  end

  MiniPick.start({
    source = {
      name = 'LSP Diagnostics',
      items = items,
      choose = function(item)
        local diag = item.diag
        -- Store the diagnostic info to use after picker closes
        local target_line = diag.lnum + 1
        local target_col = diag.col or 0
        
        -- Schedule the jump to happen after the picker closes
        vim.schedule(function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Validate buffer is still valid
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          
          -- Get buffer line count and validate line number
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          if target_line < 1 or target_line > line_count then
            return
          end
          
          -- Get the line length to validate column
          local line_content = vim.api.nvim_buf_get_lines(bufnr, target_line - 1, target_line, false)[1] or ''
          local line_length = #line_content
          local safe_col = math.min(target_col, math.max(0, line_length))
          
          -- Jump to the diagnostic location
          local winid = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_cursor(winid, { target_line, safe_col })
          vim.cmd('normal! zz') -- Center the line
        end)
      end,
    }
  })
end)


-- avante ai suggestion
map('n', '<leader>z', ':AvanteToggle<CR>')