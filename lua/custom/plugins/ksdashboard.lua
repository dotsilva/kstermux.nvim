return {
  -- alpha-nvim dashboard (Restored)
  {
    'goolord/alpha-nvim',
    lazy = false,
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.header.val = vim.split(
        [[
                                   .-----.          
        .----------------------.   | === |          
        |.-""""""""""""""""""-.|   |-----|          
        ||                    ||   | === |          
        ||   KICKSTART.NVIM   ||   |-----|          
        ||                    ||   | === |          
        ||                    ||   |-----|          
        ||:Tutor              ||   |:::::|          
        |'-..................-'|   |____o|          
        `"")----------------(""`   ___________      
       /::::::::::|  |::::::::::\  \ no mouse \     
      /:::========|  |==hjkl==:::\  \ required \    
     '""""""""""""'  '""""""""""""'  '""""""""""'   
]],
        '\n'
      )

      dashboard.section.buttons.val = {
        dashboard.button('e', 'New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('r', 'Recent files', ':Telescope oldfiles <CR>'),
        dashboard.button('q', 'Quit Neovim', ':qa<CR>'),
      }

      dashboard.section.header.opts.hl = 'Type'
      dashboard.section.buttons.opts.hl = 'Function'
      dashboard.opts.layout[1].val = 2

      alpha.setup(dashboard.config)
    end,
  },
}
