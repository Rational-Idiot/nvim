return {
	{
		"Rational-Idiot/template.nvim",
		config = function()
			require("template").setup({
				template_dir = vim.fn.stdpath("config") .. "/templates",
			})
			vim.keymap.set("n", "<leader>ct", "<cmd>Template<CR>", { desc = "Inserts a template" })
		end,
	},
}
