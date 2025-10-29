-- lua/plugins/kslsp.lua
--
-- THIS FILE OVERRIDES THE DEFAULT KICKSTART 'neovim/nvim-lspconfig'
--
-- This file is now the SINGLE SOURCE OF TRUTH for all tools
-- to be installed by 'mason-tool-installer', because the
-- default 'init.lua' runs the installer inside this plugin's config.

return {
  {
    'neovim/nvim-lspconfig',
    -- We replace the entire config function
    config = function()
      -- Default lsp-attach autocmd
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Kickstart merges on_attach functions automatically
          -- We can add specific keymaps here if needed
        end,
      })

      -- Get default LSP capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      --
      -- 1. DEFINE ALL SERVERS (LSPs)
      --
      local servers = {
        -- Default from kickstart
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- FIX: Enable stricter diagnostics for lua_ls
              diagnostics = {
                -- Get diagnostics for undefined globals
                globals = { 'vim' },
                -- Don't disable any diagnostics (default is to disable 'undefined-global')
                disable = {},
              },
              -- This tells lua_ls to not ignore unused variables
              workspace = {
                checkThirdParty = false,
              },
              -- End of FIX
            },
          },
        },

        -- Our Added LSPs
        bashls = {},
        taplo = {},
        hyprls = {}, -- <<--- ADDED HYPRLAND LSP
      }

      --
      -- 2. CREATE THE MASTER INSTALL LIST
      --
      -- Start with the LSPs (hyprls is now automatically included)
      local ensure_installed = vim.tbl_keys(servers or {})

      -- Add all Formatters and Linters
      vim.list_extend(ensure_installed, {
        -- Formatters (from ksformatter.lua)
        'stylua', -- (Original from kickstart)
        'shfmt',
        'prettierd',
        -- 'taplo' is already in the LSP list

        -- Linters (from kslinter.lua)
        'luacheck',
        'shellcheck',
      })

      --
      -- 3. RUN THE INSTALLER (This is the critical part)
      --
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      --
      -- 4. CONFIGURE mason-lspconfig TO USE THE SERVERS
      --
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- Let mason-tool-installer handle installing
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- Apply capabilities
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            -- Setup the server
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
