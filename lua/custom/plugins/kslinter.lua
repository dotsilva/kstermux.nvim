return {
  -- 1. LINTER (from pclinter.lua)
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy', -- Load late
    opts = {
      linters_by_ft = {
        lua = { 'luacheck' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        zsh = { 'shellcheck' },
        css = {},
        scss = {},
        json = {},
        yaml = {},
        markdown = {},
      },
      linters = {
        luacheck = {
          args = { '--globals', 'vim' },
        },
      },
    },
    config = function()
      -- THIS STEP IS CRUCIAL (required extension)
      -- LazyExtras would configure this, in kickstart you must do it manually.
      -- This runs the linter on save and when entering the buffer.
      local lint_augroup = vim.api.nvim_create_augroup('kickstart-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        group = lint_augroup,
        pattern = '*',
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
