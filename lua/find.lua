local ignore_patterns = {
	"node_modules",
	"%.git",
	"%.cache",
	"dist",
	"build",
	"%.tmp",
	"%.log",
}

function _G.native_find(text, _)
	local files = vim.fn.glob("**/*", true, true)
	local result = {}
	for _, f in ipairs(files) do
		if vim.fn.isdirectory(f) == 0 then
			local skip = false
			for _, pat in ipairs(ignore_patterns) do
				if f:match(pat) then
					skip = true
					break
				end
			end
			if not skip then
				result[#result + 1] = f
			end
		end
	end
	return vim.fn.matchfuzzy(result, text)
end
vim.opt.findfunc = "v:lua.native_find"

vim.keymap.set("n", "<leader>sf", ":find ", { silent = false })

-- Open buffers
local function search_buffers()
 local items = {}

  for _, buffer in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    if buffer.name ~= "" then
      table.insert(items, {
        bufnr = buffer.bufnr,
        filename = buffer.name,
        lnum = buffer.lnum,
      })
    end
  end

  vim.fn.setqflist({}, "r", {
    title = "Open buffers",
    items = items,
  })

  vim.cmd("copen")
end
vim.keymap.set("n", "<leader><Space>", search_buffers, { silent = false })

