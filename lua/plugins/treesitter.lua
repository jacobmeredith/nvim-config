return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
	opts = {
    install = { "odin" }
	}
}
