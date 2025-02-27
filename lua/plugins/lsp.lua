return {
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Decodetalkers/csharpls-extended-lsp.nvim"
    },
    config = function()
      require('mason').setup {}
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "bicep", "csharp_ls", "ts_ls", "jsonls", "bashls", "marksman", "yamlls", "texlab" }
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup {}
        end,
        ["csharp_ls"] = function()
          local config = {
            handlers = {
              ["textDocument/definition"] = require('csharpls_extended').handler,
              ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
            },
          }

          lspconfig.csharp_ls.setup(config)
        end,
        ["angularls"] = function()
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
        end,
      })
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

          -- Go to decompiled definition (C#)
          vim.keymap.set('n', '<leader>gcd', "<cmd>Telescope csharpls_definition<cr>",
            { desc = '[ ] Find existing buffers' })
        end,
      })

      require('lspsaga').setup({
        symbol_in_winbar = {
          enable = false
        }
      })
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }
  },
  {
    "TheLeoP/powershell.nvim",
    ---@type powershell.user_config
    opts = {
      bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
    }
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
