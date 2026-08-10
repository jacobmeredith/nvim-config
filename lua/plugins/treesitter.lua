return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		local treesitter = require('nvim-treesitter')
		treesitter.setup()

		vim.api.nvim_create_autocmd('FileType', {
			callback = function(args)
				local has_parser = pcall(vim.treesitter.start, args.buf)
				if has_parser then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
