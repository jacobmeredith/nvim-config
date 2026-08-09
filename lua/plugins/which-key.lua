return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    spec = {
      { '<leader>b', group = '[B]uffer' },
      { '<leader>s', group = '[S]earch' },
    },
  },
}
