vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1

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
vim.opt.swapfile = false
vim.opt.spell = false
vim.opt.clipboard = "unnamedplus"
vim.opt.shell = "/bin/bash"

vim.opt.foldmethod = "expr"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = "getline(v:foldstart)"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

require("config.lazy")

pcall(require, "current-theme")
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
vim.keymap.set(
	{ "n", "i" },
	"<C-CR>",
	"<Cmd>Coop<CR>",
	{ noremap = true, desc = "Run the current file and paste from clipboard" }
)

--Adding Templates
vim.keymap.set("i", "<C-l>", function()
	require("Customs.escape").esacape()
end, { desc = "Jump after the next ),],},\",'", noremap = true })

-- Make the file for the next question of codeforces
vim.keymap.set("n", "<leader>nq", function()
	local current = vim.fn.expand("%:t")
	local dir = vim.fn.expand("%:p:h")

	local contest, letter, ext = current:match("^(%d+)([A-Z])%.(%w+)$")

	if not contest then
		print("Filename not in expected format (e.g. 2193A.cpp)")
		return
	end

	local next_letter = string.char(letter:byte() + 1)

	local new_file = string.format("%s/%s%s.%s", dir, contest, next_letter, ext)

	vim.cmd("edit " .. new_file)
end, { desc = "Create next CF problem file" })

-- Open the floaterminal
vim.keymap.set({ "n", "t" }, "<leader>tt", function()
	local ok, term = pcall(require, "Customs.floaterminal")
	if ok and type(term) == "table" and term.toggle_terminal then
		term.toggle_terminal()
	else
		vim.notify("Failed to load floating terminal module", vim.log.levels.ERROR)
	end
end, { desc = "Toggle a floating terminal", noremap = true })

-- Run the binary of the current c++ file in floaterminla (Compiled to /tmp)
vim.keymap.set("n", "<leader>cr", function()
	local ok, term = pcall(require, "Customs.floaterminal")
	if ok and type(term) == "table" and term.run_current_cpp then
		term.run_current_cpp()
	else
		vim.notify("Failed to load floating terminal module", vim.log.levels.ERROR)
	end
end, { desc = "Run current C++ (runcp)", noremap = true })

vim.keymap.set("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end
end, { desc = "Smart Esc: clear highlights or escape" })

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
vim.keymap.set("n", "<leader>qf", "<cmd>lua vim.diagnostic.setqflist()<CR>", { desc = "set Diagnostics in qf list" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight while copying text",
	group = vim.api.nvim_create_augroup("Highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float(nil, {
		focus = false,
		scope = "cursor",
		border = "rounded",
	})
end, { desc = "Show line diagnostics" })

vim.lsp.enable("gleam")

local themes = {
	"tokyonight-night",
	"gruvbox",
	"catppuccin-mocha",
	"rose-pine-main",
	"nord",
}

vim.keymap.set("n", "<leader>th", function()
	vim.ui.select(themes, { prompt = "Select colorscheme:" }, function(choice)
		if not choice then
			return
		end

		vim.cmd.colorscheme(choice)

		local path = vim.fn.stdpath("config") .. "/lua/current-theme.lua"
		local f = io.open(path, "w")
		if f then
			f:write(string.format('vim.cmd.colorscheme("%s")\n', choice))
			f:close()
		end
	end)
end, { desc = "Switch colorscheme" }) --Package Manager
