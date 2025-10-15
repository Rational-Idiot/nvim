return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim", "andrew-george/telescope-themes" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						-- Common
						"node_modules",
						"%.lock$",
						"%.log$",
						"%.png$",
						"%.jpg$",
						"%.jpeg$",
						"%.gif$",
						"%.webp$",
						"%.zip$",
						"%.tar$",
						"%.gz$",
						"%.7z$",
						"%.rar$",
						"^secret/",

						-- Go
						"^vendor/",
						"%.test$",
						"%.exe$",
						"%.out$",

						-- Rust
						"^target/",
						"%.rlib$",
						"Cargo.lock",

						-- C / C++
						"^build/",
						"^bin/",
						"%.o$",
						"%.obj$",
						"%.a$",
						"%.so$",
						"%.dll$",
						"%.dylib$",
						"%.exe$",
						"%.out$",

						-- Misc cache
						"^%.cache/",
						"^__pycache__/",
						"%.class$",
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", function()
				local dirs = {
					"~/code",
					"~/caelestia",
					"~/Downloads",
					"~/.config",
				}
				vim.ui.select(dirs, {
					prompt = "Select search dir: ",
				}, function(choice)
					if choice then
						require("telescope.builtin").fd({
							cwd = vim.fn.expand(choice),
						})
					end
				end)
			end, { desc = "Telescope find files in home directory" })

			vim.keymap.set("n", "<M-f>", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Telescope treesitter" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope Diagnostics" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
}
