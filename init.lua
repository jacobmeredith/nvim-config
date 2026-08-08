vim.g.mapleader = " "
vim.g.maplocalleader = ' '

require("config.lazy")

require("options")
require("lsp")
require("colorscheme")
require("netrw")
require("statusline")
require("find")
require("grep")
require("autocommands")
require("diagnostics")
require("formatting")
require("keymaps")
