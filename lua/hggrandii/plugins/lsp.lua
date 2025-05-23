return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "folke/trouble.nvim",
    "akinsho/flutter-tools.nvim",
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-lint",
    "mhartington/formatter.nvim",
  },

  config = function()
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        -- "pyright",
        -- "ruff_lsp",
        "ruff",
        "eslint",
        "zls",
      },
    })

    local mason_registry = require("mason-registry")
    local tools_to_install = { "ruff" }
    for _, tool in ipairs(tools_to_install) do
      if not mason_registry.is_installed(tool) then
        vim.cmd("MasonInstall " .. tool)
      end
    end

    local on_attach = function(client, bufnr)
      print("🔥 LSP ATTACHED: " .. client.name .. " to buffer " .. bufnr)

      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end
      local opts = { noremap = true, silent = true }

      print("🔧 Setting LSP keymaps for buffer " .. bufnr)




      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end
      local opts = { noremap = true, silent = true }

      buf_set_keymap("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
      buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
      buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
      buf_set_keymap(
        "n",
        "<space>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        opts
      )
      buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
      buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      buf_set_keymap(
        "n",
        "<leader>e",
        "<cmd>lua vim.defer_fn(function() vim.diagnostic.open_float(nil, { focusable = false }) end, 10)<CR>",
        opts
      )
      -- buf_set_keymap("n", "<", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
      -- buf_set_keymap("n", ">", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
      buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
      buf_set_keymap("n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    end

    require("lspconfig").lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    })

    require("lspconfig").rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").eslint.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      settings = {
        workingDirectory = { mode = "auto" }
      }
    })

    require("lspconfig").gopls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- require("lspconfig").pyright.setup({
    -- 	capabilities = capabilities,
    -- 	on_attach = function(client, bufnr)
    -- 		client.server_capabilities.documentFormattingProvider = false
    -- 	end,
    -- 	settings = {
    -- 		python = {
    -- 			analysis = {
    -- 				typeCheckingMode = "basic",
    -- 				autoSearchPaths = true,
    -- 				useLibraryCodeForTypes = true,
    -- 				diagnosticMode = "workspace",
    -- 			},
    -- 		},
    -- 	},
    -- 	before_init = function(_, config)
    -- 		local path = vim.fn.getcwd() .. "/.venv/bin/python"
    -- 		if vim.fn.filereadable(path) == 1 then
    -- 			config.settings.python.pythonPath = path
    -- 		end
    -- 	end,
    -- })

    require("lspconfig").pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            diagnosticMode = "none",
            typeCheckingMode = "off",

            autoSearchPaths = false,
            useLibraryCodeForTypes = false,
          },
        },
      },
    })

    require("lspconfig").ruff.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").zls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("flutter-tools").setup({
      lsp = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
    })

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }),
    })

    require("trouble").setup({})

    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
      virtual_text = {
        severity = { min = vim.diagnostic.severity.WARN },
      },
      signs = {
        severity = { min = vim.diagnostic.severity.WARN },
      },
      underline = {
        severity = { min = vim.diagnostic.severity.WARN },
      },
    })

    local prettier = function()
      return {
        exe = "prettier",
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end

    require("lint").linters_by_ft = {
      python = { "ruff" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.py",
      command = "FormatWrite",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
      end,
    })
  end,
}
