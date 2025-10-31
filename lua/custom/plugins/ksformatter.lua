-- lua/custom/plugins/termux-formatter-fix.lua
--
-- This file OVERRIDES the default 'stevearc/conform.nvim'
-- spec in init.lua.
--
-- ### ADAPTED FOR TERMUX (v3 - ZIG Support) ###
--
-- 1. Added explicit paths for all system binaries.
-- 2. PRETTIERD PATCH: Added explicit path for prettierd.
-- 3. ZIG PATCH: Added 'zls' formatter.
--

return {
  {
    'stevearc/conform.nvim',
    -- This 'opts' table REPLACES the one in init.lua
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      -- TERMUX PATCH: Explicit paths to system binaries
      formatters = {
        stylua = {
          command = '/data/data/com.termux/files/usr/bin/stylua',
        },
        shfmt = {
          command = '/data/data/com.termux/files/usr/bin/shfmt',
        },
        taplo = {
          command = '/data/data/com.termux/files/usr/bin/taplo',
        },
        prettierd = {
          command = '/data/data/com.termux/files/usr/bin/prettierd',
        },
        -- ZIG PATCH:
        zls = {
          command = '/data/data/com.termux/files/usr/bin/zls',
          args = { 'fmt' }, -- O comando é 'zls fmt'
        },
      },

      -- Formatter list by filetype
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        toml = { 'taplo' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        -- ZIG PATCH:
        zig = { 'zls' },
      },
    },
  },
}
