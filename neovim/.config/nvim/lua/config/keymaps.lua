-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal
vim.keymap.set("n", "<C-LeftMouse>", "gf", { desc = "Open File Under Cursor" })
