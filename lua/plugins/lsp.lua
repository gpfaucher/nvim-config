return {
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local dynamic_node_module_dir = vim.fs.find(
        { 'node_modules' },
        { limit = math.huge, type = 'directory', stop = 'node_modules' }
      )[1] or ''

      local cmd = { dynamic_node_module_dir .. "/.bin/ngserver", "--stdio", "--tsProbeLocations", "./node_modules",
        "--ngProbeLocations", dynamic_node_module_dir }

      lspconfig.angularls.setup {
        cmd = cmd,
        on_new_config = function(new_config)
          new_config.cmd = cmd
        end,
      }

      lspconfig.lua_ls.setup({})
      lspconfig.ts_ls.setup {}
    end
  },

  {
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true }
          vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>Lspsaga finder<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>Lspsaga goto_type_definition<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<cr>', opts)
          vim.keymap.set('n', 'ca', '<cmd>Lspsaga code_action<cr>', opts)
        end,
      })

      require('lspsaga').setup({})
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
