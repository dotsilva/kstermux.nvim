return {
  'stevearc/oil.nvim',

  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  keys = {
    -- open oil
    {
      '<leader>o',
      function()
        require('oil').open()
      end,
      desc = 'Open [O]il Explorer',
    },
  },

  config = function()
    -- 1. 'oil' Configuration
    require('oil').setup {
      -- 2. FIX FOR THE "SMALLER SPACE" (SPLIT) PROBLEM
      --    This is the correct configuration.
      --    When 'false', <CR> (Enter) opens the
      --    file in the CURRENT WINDOW, instead of a split.
      default_file_explorer = false,

      columns = {
        'icon',
      },
      view_options = {
        show_hidden = true,
      },
      -- same <leader>o closes oil
      keymaps = {
        ['<leader>o'] = 'actions.close',
      },
    }

    --    This ensures that oil opens on startup.
    local oil_on_start_group = vim.api.nvim_create_augroup('OilOnStart', { clear = true })
    vim.api.nvim_create_autocmd('VimEnter', {
      group = oil_on_start_group,
      pattern = '*',
      nested = true,
      callback = function()
        -- If no file was passed as an argument
        if vim.fn.argc() == 0 then
          -- And if the current buffer is not special (lazy, mason, etc.)
          local ftype = vim.bo.filetype
          if ftype ~= 'oil' and ftype ~= 'lazy' and ftype ~= 'mason' then
            -- Then open 'oil' in the current directory.
            vim.cmd.Oil '.'
          end
        end
      end,
    })
  end,
}
