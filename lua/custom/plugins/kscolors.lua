-- lua/plugins/kscolors.lua

return {
  'NvChad/nvim-colorizer.lua',
  lazy = false,
  priority = 1000,

  config = function()
    require('colorizer').setup {
      -- 1. The filetypes you want
      filetypes = {
        'css',
        'scss',
        'toml',
        'yaml',
        'ini',
        'hyprlang', -- <--- FIX APPLIED
        'javascript',
        'typescript',
        'dosini',
        'conf',
        'properties',
      },

      -- 2. THE FIX:
      -- We need to re-define the options that were lost
      -- when overriding 'filetypes'.
      user_default_options = {
        -- This is the main flag that enables (rgb, rgba, hsl, etc.)
        css = true,

        -- Just to be sure, we also explicitly enable:
        rgb_fn = true,
        names = false,
      },
    }
  end,
}
