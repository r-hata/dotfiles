-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false
vim.opt.mouse = ""
vim.g.python3_host_prog = (function()
  local python3_path = os.getenv("HOME") .. "/.venv/bin/python3"
  if vim.fn.filereadable(python3_path) == 0 then
    python3_path = ""
  end
  return python3_path
end)()
