-- lua/custom/plugins/termux-formatter-fix.lua
--
-- This file OVERRIDES the default 'stevearc/conform.nvim'
-- spec in init.lua.
--
-- ### ADAPTED FOR TERMUX (v2) ###
--
-- 1. Added explicit paths for all system binaries.
-- 2. PRETTIERD PATCH: Added explicit path for prettierd
--    to stop using the Mason version.
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
        -- PRETTIERD PATCH:
        prettierd = {
          command = '/data/data/com.termux/files/usr/bin/prettierd',
        },
      },

      -- Formatter list by filetype (from your original ksformatter.lua)
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
      },
    },
  },
}
