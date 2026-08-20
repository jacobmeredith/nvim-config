vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.o.breakindent = true
vim.o.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.o.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.scrolloff = 999

vim.o.autoread = true
vim.o.laststatus = 3
vim.o.cmdheight = 0
