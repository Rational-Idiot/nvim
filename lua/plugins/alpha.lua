return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	init = false,
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		local logo = [[
__/\\\\\\\\\\\\________________________________________________________________________________________        
 _\/\\\////////\\\______________________________________________________________________________________       
  _\/\\\______\//\\\_______________________________/\\\\\\\\_____________________________________________      
   _\/\\\_______\/\\\__/\\\____/\\\__/\\/\\\\\\____/\\\////\\\_____/\\\\\\\\______/\\\\\_____/\\/\\\\\\___     
    _\/\\\_______\/\\\_\/\\\___\/\\\_\/\\\////\\\__\//\\\\\\\\\___/\\\/////\\\___/\\\///\\\__\/\\\////\\\__    
     _\/\\\_______\/\\\_\/\\\___\/\\\_\/\\\__\//\\\__\///////\\\__/\\\\\\\\\\\___/\\\__\//\\\_\/\\\__\//\\\_   
      _\/\\\_______/\\\__\/\\\___\/\\\_\/\\\___\/\\\__/\\_____\\\_\//\\///////___\//\\\__/\\\__\/\\\___\/\\\_  
       _\/\\\\\\\\\\\\/___\//\\\\\\\\\__\/\\\___\/\\\_\//\\\\\\\\___\//\\\\\\\\\\__\///\\\\\/___\/\\\___\/\\\_ 
        _\////////////______\/////////___\///____\///___\////////_____\//////////_____\/////_____\///____\///__
]]
		dashboard.section.header.val = vim.split(logo, "\n")
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd>Telescope fd<cr>"),
      dashboard.button("e", " " .. " New file",        [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", " " .. " Recent files",    [[<cmd>Telescope oldfiles<cr>]]),
      dashboard.button("g", " " .. " Find text",       [[<cmd>Telescope live_grep<cr>]]),
      dashboard.button("c", " " .. " Config",          "<cmd>edit $MYVIMRC<cr>"),
      dashboard.button("s", " " .. " Restore Session", "<cmd>lua require('persistence').load()<cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "LazyVimStarted",
			callback = function()
				local handle = io.popen("fortune")
				local fortune = handle and handle:read("*a") or "💡 Fortune not found."
				if handle then
					handle:close()
				end
				dashboard.section.footer.val = fortune
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
