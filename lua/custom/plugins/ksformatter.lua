-- lua/plugins/ksformatter.lua
return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Kickstart default
        lua = { 'stylua' },

        -- Your formatters
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },

        -- Added for TOML
        toml = { 'taplo' },

        -- Other formatters
        css = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
      },
    },
  },
}
