return {
  {
    'tahayvr/sunset-drive.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.defer_fn(function()
        vim.cmd.colorscheme 'sunsetdrive'
      end, 0)
    end,
  },
}
