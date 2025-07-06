local M = {}

local targets = {
	[")"] = true,
	["]"] = true,
	["}"] = true,
	["'"] = true,
	['"'] = true,
}

function M.esacape()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	for i = col + 1, #line do
		local char = line:sub(i, i)
		if targets[char] then
			vim.api.nvim_win_set_cursor(0, { row, i })
		end
	end
end

return M
