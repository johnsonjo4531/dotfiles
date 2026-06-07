-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end
