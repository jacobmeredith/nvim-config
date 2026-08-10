return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		local treesitter = require('nvim-treesitter')
		treesitter.setup()
		local installing = {}

		local function start(bufnr, lang)
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			local has_parser = pcall(vim.treesitter.start, bufnr, lang)
			if has_parser then
				vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end

		vim.api.nvim_create_autocmd('FileType', {
			callback = function(args)
				local filetype = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(filetype) or filetype

				if vim.tbl_contains(treesitter.get_installed(), lang) then
					start(args.buf, lang)
					return
				end

				if not vim.tbl_contains(treesitter.get_available(), lang) then
					return
				end

				if installing[lang] then
					table.insert(installing[lang], args.buf)
					return
				end

				installing[lang] = { args.buf }
				treesitter.install(lang):await(function(err, installed)
					local buffers = installing[lang]
					installing[lang] = nil

					vim.schedule(function()
						if err or not installed then
							vim.notify(
								('Failed to install Tree-sitter parser for %s: %s'):format(lang, err or 'unknown error'),
								vim.log.levels.WARN
							)
							return
						end

						for _, bufnr in ipairs(buffers) do
							start(bufnr, lang)
						end
					end)
				end)
			end,
		})
	end,
}
