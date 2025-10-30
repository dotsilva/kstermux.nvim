-- lua/custom/plugins/ksoil.lua
return {
  'stevearc/oil.nvim',

  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    -- 1. Configuração do 'oil'
    require('oil').setup {
      -- 2. FIX DO PROBLEMA DE "ESPAÇO MENOR" (SPLIT)
      --    Esta é a configuração correta.
      --    Quando 'false', o <CR> (Enter) abre o
      --    arquivo na JANELA ATUAL, em vez de um split.
      default_file_explorer = false,

      columns = {
        'icon',
      },
      view_options = {
        show_hidden = true,
      },
      -- A seção 'keymaps' foi REMOVIDA
      -- pois ela estava causando o erro.
    }

    -- 3. FIX DO PROBLEMA "NÃO FUNCIONOU MAIS" (Mantido da V3)
    --    Isso garante que o oil abra no início.
    local oil_on_start_group = vim.api.nvim_create_augroup('OilOnStart', { clear = true })
    vim.api.nvim_create_autocmd('VimEnter', {
      group = oil_on_start_group,
      pattern = '*',
      nested = true,
      callback = function()
        -- Se nenhum arquivo foi passado como argumento
        if vim.fn.argc() == 0 then
          -- E se o buffer atual não é especial (lazy, mason, etc.)
          local ftype = vim.bo.filetype
          if ftype ~= 'oil' and ftype ~= 'lazy' and ftype ~= 'mason' then
            -- Então abra o 'oil' no diretório atual.
            vim.cmd.Oil '.'
          end
        end
      end,
    })
  end,
}
