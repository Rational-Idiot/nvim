return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local cpplint = {
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "c", "cpp", "h", "hpp" },
			generator = null_ls.generator({
				command = "cpplint",
				args = { "--quiet", "$FILENAME" },
				format = "line", -- cpplint outputs one error per line
				to_stdin = false,
				from_stderr = true, -- cpplint outputs diagnostics on stderr
				on_output = function(line, params)
					-- cpplint error format example:
					-- path/to/file.cpp:123:  Missing space before ( in if(  [whitespace/parens] [5]
					local row, col, message = line:match(":(%d+):%s+(.*)%s+%[.*%]%s+%[%d+%]")
					if row and message then
						return {
							row = tonumber(row),
							col = 1,
							message = message,
							severity = null_ls.diagnostics.severities["warning"],
							source = "cpplint",
						}
					end
				end,
			}),
		}

		local formatting = null_ls.builtins.formatting
		local completion = null_ls.builtins.completion
		local diagnostics = null_ls.builtins.diagnostics

		null_ls.setup({
			sources = {
				formatting.stylua,
				formatting.clang_format,
				formatting.prettier,
				diagnostics.checkmake,
				require("none-ls.diagnostics.eslint"),
				require("none-ls.diagnostics.cpplint"),

				formatting.gofumpt,
				formatting.markdownlint,
				formatting.shfmt,
				completion.spell,
			},
			--format on save
			on_attach = function(client, bufnr)
				if client.name == "null-ls" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(format_client)
									return format_client.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "File formatter" })
	end,
}
