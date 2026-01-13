local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map('n', '<leader>qq', ':bw!<CR>')
map('n', '<leader>h', ':noh<CR>')


-- git branches
local function parse_git_lines(output)
  local lines = {}
  for line in output:gmatch('[^\n]+') do
    table.insert(lines, line)
  end
  return lines
end


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
end)



-- Telescope keybindings
local map = vim.keymap.set
local builtin = require("telescope.builtin")

-- Files / buffers
map("n", "<leader>ff", function()
  builtin.find_files({
    hidden = true,
  })
end, { desc = "Find files (including hidden)" })

map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })

-- Project search (keyword across whole repo)
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })

-- Errors & warnings (ALL files)
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })

-- LSP
map("n", "gr", builtin.lsp_references, { desc = "LSP references" })
map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })



-- avante ai suggestion
map('n', '<leader>z', ':AvanteToggle<CR>')

-- Diagnostic float
map("n", "<leader>e", vim.diagnostic.open_float)

-- directory tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })


--git blame of full file
map("n", "<leader>gbb", function()
require("gitsigns").blame({ full = true })
end, { desc = "Git blame (full)" })



