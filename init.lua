vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

--Package Manager
require("config.lazy")

--Sync the vim yank reg and the system clipboard
vim.opt.clipboard = "unnamedplus"

--Moving between splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

--Adding Templates
vim.keymap.set("i", "<C-l>", function()
  require("Customs.escape").esacape()
end, { desc = "Jump after the next ),],},\",'", noremap = true })

