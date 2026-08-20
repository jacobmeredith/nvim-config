return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters = {
      odinfmt = {
        cwd = function(_, ctx)
          local config = vim.fs.find('odinfmt.json', {
            path = ctx.dirname,
            upward = true,
          })[1]
          return config and vim.fs.dirname(config)
        end,
        require_cwd = true,
      },
    },
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      svelte = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      liquid = { 'prettier' },
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      odin = { "odinfmt" }
    },
    format_on_save = {
      lsp_format = 'fallback',
      async = false,
      timeout_ms = 1000,
    },
  },
}
