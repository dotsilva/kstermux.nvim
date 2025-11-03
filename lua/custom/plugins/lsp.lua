-- lua/custom/plugins/kslsp.lua
--
-- This file completely OVERRIDES the default 'neovim/nvim-lspconfig'
-- spec in init.lua.
--
-- ### ADAPTED FOR TERMUX
--
-- 1. Added 'mason = false'
-- 2. Cleaned 'mason-tool-installer' list COMPLETELY.
-- Mason will no longer install any LSPs or tools.
--
--

return {
  {
    'neovim/nvim-lspconfig',
    -- This entire 'config' function REPLACES the one in init.lua
    config = function()
      -- Default lsp-attach autocmd (from kickstart)
      vim.api.nvim_create_autocmd('LspAttach', {
-- [[ ... (rest of on_attach function) ... ]]
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        end,
      })

      -- Diagnostic Config (from kickstart)
      vim.diagnostic.config {
-- [[ ... (rest of diagnostic config) ... ]]
        },
      }

      -- Get default LSP capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      --
      -- 1. DEFINE SERVERS (WITH TERMUX PATCH)
      --
      local servers = {
        lua_ls = {
          mason = false,
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                globals = { 'vim' },
                disable = {},
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        bashls = {
          mason = false,
        },
        taplo = {
          mason = false,
        },
        hyprls = {
          mason = false,
        },
        --[[ REMOVED ZLS
        zls = {
          mason = false,
        },
        ]]
        marksman = {
          mason = false,
        },
        -- ADDED: elixirls will be managed by Mason,
        -- so we do NOT set 'mason = false' or 'cmd'
        elixirls = {},
      }

      --
      -- 2. MASON-TOOL-INSTALLER (TERMUX PATCHED)
      --
      -- ADDED 'elixirls' for installation by Mason
      local ensure_installed = { 'elixirls' }
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      --
      -- 3. MASON-LSPCONFIG HANDLER (Modified to include elixirls)
      --
      require('mason-lspconfig').setup {
        -- ADDED 'elixirls' for setup by mason-lspconfig
        ensure_installed = { 'elixirls' },
        -- Enable automatic installation ONLY for elixirls
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            vim.lsp.config(server_name, server)
          end,
        },
      }

      --
      -- 4. ### TERMUX FIX ###
      -- EXPLICITLY SET UP & ENABLE EXTERNALLY-MANAGED LSPs
      -- (This list should NOT include 'elixirls')
      --
      local external_servers = { 'lua_ls', 'bashls', 'taplo', 'hyprls', 'marksman' }
      for _, server_name in ipairs(external_servers) do
        local server_opts = servers[server_name] or {}
        server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})

        vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
