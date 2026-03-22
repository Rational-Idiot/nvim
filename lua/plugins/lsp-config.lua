return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Get blink.cmp capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

			-- Common on_attach

			local on_attach = function(client, bufnr)
				-- Prefer HLS formatting for Haskell
				if vim.bo[bufnr].filetype == "haskell" and client.name == "null-ls" then
					client.server_capabilities.documentFormattingProvider = false
				end

				local opts = { buffer = bufnr, silent = true }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- {Chatgpt code start}
				vim.keymap.set("n", "gK", function()
					-- Make hover parameters at current cursor
					local params = vim.lsp.util.make_position_params()

					-- Request hover from LSP synchronously
					local results = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 1000)
					if not results or vim.tbl_isempty(results) then
						print("No hover information available")
						return
					end

					-- Extract hover contents
					local contents
					for _, res in pairs(results) do
						if res.result and res.result.contents then
							contents = vim.lsp.util.convert_input_to_markdown_lines(res.result.contents)
							-- Trim empty lines using modern API
							contents = vim.split(table.concat(contents, "\n"), "\n", { trimempty = true })
							break
						end
					end

					if not contents or vim.tbl_isempty(contents) then
						print("No hover contents")
						return
					end

					-- Open vertical split and insert hover
					vim.cmd("vnew")
					vim.bo.filetype = "markdown"
					vim.bo.modifiable = true
					vim.api.nvim_buf_set_lines(0, 0, -1, false, contents)
					vim.bo.modifiable = false
				end, opts) -- {SlopGPT code end}

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

				-- Auto format on save
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false }),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								async = false,
								filter = function(fmt_client)
									if vim.bo[bufnr].filetype == "haskell" then
										return fmt_client.name == "hls"
									else
										return fmt_client.name ~= "hls"
									end
								end,
							})
						end,
					})
				end
			end

			local lspconfig = vim.lsp.config

			-- Setup each server
			local servers = {
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							checkOnSave = true, -- modern syntax
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
						},
					},
				},
				hls = {
					cmd = { "haskell-language-server-wrapper", "--lsp" },
					settings = {
						haskell = {
							formattingProvider = "ormolu",
						},
					},
				},
				clangd = {},
				gopls = {},
				vtsls = {},
				jsonls = {},
				tailwindcss = {},
				ruff = {},
				eslint = {},
			}

			for server, config in pairs(servers) do
				-- Define server in vim.lsp.configs if not already defined
				if not lspconfig[server] then
					local default = require("lspconfig.server_configurations." .. server).default_config
					lspconfig[server] = default
				end

				-- Register server for auto-attach (do NOT call vim.lsp.start)
				vim.lsp.config(
					server,
					vim.tbl_deep_extend("force", {
						on_attach = on_attach,
						capabilities = capabilities,
					}, config)
				)
			end
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
		opts = {
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"clangd",
				"eslint",
				"gopls",
				"jsonls",
				"ruff",
				"tailwindcss",
				"rust_analyzer",
				"hls",
			},
			automatic_installation = true,
		},
	},
}
