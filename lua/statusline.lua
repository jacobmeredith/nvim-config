local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
vim.api.nvim_set_hl(0, "StlMode", { fg = pms.fg, bg = vis.bg })
vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

function _G._statusline()
	local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
	local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
	local path = vim.b.rel_path or "%f"

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	local labels = { " ", " ", " ", " " }
	local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
		end
	end

	return "%#StlMode# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. vim.bo.filetype .. " %l:%c"
end

local function update_git_info(args)
	local file = vim.api.nvim_buf_get_name(args.buf)
	local cwd = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()

	local root_result = vim.system(
		{ "git", "rev-parse", "--show-toplevel" },
		{ cwd = cwd, text = true }
	):wait()

	if root_result.code ~= 0 then
		vim.b[args.buf].git_branch = nil
		vim.b[args.buf].rel_path = vim.fn.fnamemodify(file, ":~")
		return
	end

	local root = vim.trim(root_result.stdout)
	local branch_result = vim.system(
		{ "git", "branch", "--show-current" },
		{ cwd = cwd, text = true }
	):wait()
	local branch = vim.trim(branch_result.stdout or "")

	vim.b[args.buf].git_branch = branch ~= "" and branch or nil
	vim.b[args.buf].rel_path = vim.fs.relpath(root, file)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = update_git_info,
})

update_git_info({ buf = vim.api.nvim_get_current_buf() })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline()"
