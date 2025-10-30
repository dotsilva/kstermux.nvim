-- ~/.config/nvim/lua/custom/plugins/ksdashboard.lua
return {
  {
    'goolord/alpha-nvim',
    lazy = false,
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.header.val = vim.split(
        [[
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
]],
        '\n',
        { trimempty = true }
      )

      dashboard.section.header.opts.hl = 'Type'
      dashboard.section.header.opts.position = 'center'

      dashboard.section.buttons.val = {
        dashboard.button('e', 'New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('r', 'Recent files', ':Telescope oldfiles <CR>'),
        dashboard.button('q', 'Quit Neovim', ':qa<CR>'),
      }
      dashboard.section.buttons.opts.hl = 'Function'
      dashboard.section.buttons.opts.position = 'center'
      dashboard.section.buttons.opts.spacing = 1

      -- footer fixed
      local ok, lazy = pcall(require, 'lazy')
      local footer_text = ' '
      if ok and lazy and type(lazy.stats) == 'function' then
        local s = lazy.stats()
        footer_text = string.format('⚡ Neovim loaded %d/%d plugins in %.2fms', s.loaded or 0, s.count or 0, s.startuptime or 0.0)
      end

      dashboard.section.footer.val = footer_text
      dashboard.section.footer.opts.hl = 'Comment'
      dashboard.section.footer.opts.position = 'center'

      dashboard.opts.layout = {
        { type = 'padding', val = 7 },
        dashboard.section.header,
        { type = 'padding', val = 2 },
        dashboard.section.buttons,
        { type = 'padding', val = 1 },
        dashboard.section.footer,
      }

      -- hides details, statusline, ruler and showmode while alpha is open
      do
        local saved = {}
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          callback = function()
            -- save currently values
            saved.laststatus = vim.o.laststatus
            saved.showtabline = vim.o.showtabline
            saved.fillchars = vim.o.fillchars
            saved.ruler = vim.o.ruler
            saved.showmode = vim.o.showmode
            saved.statusline = vim.o.statusline
            saved.win_statusline = vim.wo.statusline

            -- apply fixes
            vim.opt.fillchars = vim.opt.fillchars + { eob = ' ' }
            vim.o.laststatus = 0
            vim.o.showtabline = 0
            vim.o.ruler = false
            vim.o.showmode = false
            vim.o.statusline = ''
            vim.wo.statusline = ''

            -- restores alpha buffer
            local bufnr = vim.api.nvim_get_current_buf()
            vim.api.nvim_create_autocmd('BufUnload', {
              buffer = bufnr,
              callback = function()
                vim.o.laststatus = saved.laststatus or 3
                vim.o.showtabline = saved.showtabline or 2
                vim.o.fillchars = saved.fillchars or 'eob:~'
                vim.o.ruler = saved.ruler or false
                vim.o.showmode = saved.showmode or true
                vim.o.statusline = saved.statusline or ''
                if saved.win_statusline ~= nil then
                  vim.wo.statusline = saved.win_statusline
                end
              end,
            })
          end,
        })
      end

      alpha.setup(dashboard.config)
    end,
  },
}
