return {
  -- 3. SNACKS (Corrected as per :checkhealth)
  {
    'folke/snacks.nvim',
    lazy = false, -- <--- 1: (was 'event = VeryLazy')
    priority = 1000, -- <--- 2: Added priority
    opts = {
      scroll = {
        enabled = false, -- Disable scrolling animations
      },
    },
  },

  -- vertical line
  {
    'echasnovski/mini.indentscope',
    version = false, -- or it might have a version tag

    -- Plugin options
    opts = {
      -- You can uncomment and change the symbol if you want
      symbol = '╎',
      options = { try_as_border = true },
      -- Add this line to disable animation:
      draw = { animation = require('mini.indentscope').gen_animation.none() },
    },

    -- This config function runs after the plugin is loaded
    config = function(_, opts)
      -- 1. Setup the plugin with the options defined above
      require('mini.indentscope').setup(opts)

      -- 2. Define the filetypes and buftypes to disable
      local disabled_fts = {
        alpha = true, -- This is the 'alpha-nvim' dashboard
        oil = true,
        help = true,
        dashboard = true,
        lazy = true,
        mason = true,
        NvimTree = true,
        Trouble = true,
      }

      local disabled_bts = {
        terminal = true,
        nofile = true,
      }

      -- 3. Create an autocommand to disable the plugin for those types
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*', -- Check all filetypes
        group = vim.api.nvim_create_augroup('MiniIndentScopeDisable', { clear = true }),
        callback = function()
          -- If the filetype is in our list, disable indent lines for this buffer
          if disabled_fts[vim.bo.filetype] then
            vim.b.miniindentscope_disable = true
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*', -- Check all buffers
        group = 'MiniIndentScopeDisable', -- Use the same group
        callback = function()
          -- If the buftype is in our list, disable indent lines
          if disabled_bts[vim.bo.buftype] then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },
}
