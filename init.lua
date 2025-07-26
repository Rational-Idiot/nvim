vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
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

vim.keymap.set("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end
end, { desc = "Smart Esc: clear highlights or escape" })

vim.diagnostic.config({
	virtual_text = true, -- show inline errors
	signs = true, -- show signs in gutter
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight while copying text",
	group = vim.api.nvim_create_augroup("Highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
