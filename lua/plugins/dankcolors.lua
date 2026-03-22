return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({

				base00 = '#141314',
				base01 = '#1c1b1c',
				base02 = '#201f20',
				base03 = '#7f7b85',
				base0B = '#ffda72',
				base04 = '#d0cbd8',
				base05 = '#fbf8ff',
				base06 = '#fbf8ff',
				base07 = '#fbf8ff',
				base08 = '#ff9fb2',
				base09 = '#ff9fb2',
				base0A = '#dcdae2',
				base0C = '#fbf9ff',
				base0D = '#dcdae2',
				base0E = '#f9f7ff',
				base0F = '#f9f7ff',
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
