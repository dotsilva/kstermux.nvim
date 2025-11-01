return {
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
}
