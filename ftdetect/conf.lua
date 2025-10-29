-- ~/.config/nvim-kickstart/ftdetect/conf.lua
--
-- Define filetype associations for Hyprland

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    -- Pattern 1: Any .conf inside a 'hypr' directory
    '*/hypr/*.conf',

    -- Pattern 2: Official filenames from the Hyprland ecosystem
    'hyprland.conf',
    'hypridle.conf',
    'hyprlock.conf',
    'hyprpaper.conf',
    'hyprtheme.conf',
    'hyprsunset.conf',

    -- Pattern 3: Official extension
    '*.hl',
  },
  command = 'set filetype=hyprlang',
})
