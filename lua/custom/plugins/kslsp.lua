-- lua/custom/plugins/kslsp.lua
--
-- This file completely OVERRIDES the default 'neovim/nvim-lspconfig'
-- spec in init.lua.
--
-- ### ADAPTED FOR TERMUX (v6 - Final) ###
--
-- 1. Added 'mason = false' for 'lua_ls', 'bashls', 'taplo'
--    AND 'hyprls' to force use of system binaries.
--
-- 2. Cleaned 'mason-tool-installer' list COMPLETELY.
--    Mason will no longer install any LSPs or tools.
--
-- 3. Added 'hyprls' to the explicit enable list (Step 4).
--

return {
  {
    'neovim/nvim-lspconfig',
    -- This entire 'config' function REPLACES the one in init.lua
    config = function()
      -- Default lsp-attach autocmd (from kickstart)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          -- Add keymaps from init.lua's on_attach
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        end,
      })

      -- Diagnostic Config (from kickstart)
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = ' ｪ ',
            [vim.diagnostic.severity.INFO] = '郷 ',
            [vim.diagnostic.severity.HINT] = '幻 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
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
        -- HYPRLS PATCH:
        hyprls = {
          mason = false,
        },
      }

      --
      -- 2. MASON-TOOL-INSTALLER (TERMUX PATCHED)
      --    Lista agora esta VAZIA.
      --
      local ensure_installed = {
        -- 'hyprls' removido
        -- 'prettierd' removido
      }
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      --
      -- 3. MASON-LSPCONFIG HANDLER (For Mason-managed servers)
      --
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
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
      --
      -- HYPRLS PATCH: Adicionado 'hyprls' a esta lista
      local external_servers = { 'lua_ls', 'bashls', 'taplo', 'hyprls' }
      for _, server_name in ipairs(external_servers) do
        local server_opts = servers[server_name] or {}
        server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})

        vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
