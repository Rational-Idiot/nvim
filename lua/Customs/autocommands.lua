vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	command = "startinsert",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		vim.fn.system("kitty @ set-colors --configured")
	end,
})
