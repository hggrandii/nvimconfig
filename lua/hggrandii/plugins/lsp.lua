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
				"pyright",
				"biome",
			},
		})

		local on_attach = function(client, bufnr)
			local buf_set_keymap = vim.api.nvim_buf_set_keymap
			local opts = { noremap = true, silent = true }

			buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
			buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
			buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<space>wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<space>wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
			buf_set_keymap(
				bufnr,
				"n",
				"<space>wl",
				"<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
				opts
			)
			buf_set_keymap(bufnr, "n", "<space>D", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<space>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
			buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<leader>e", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
			buf_set_keymap(bufnr, "n", ">", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<space>q", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<space>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)
			buf_set_keymap(bufnr, "n", "<leader>vca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
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

		require("lspconfig").biome.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		require("lspconfig").pyright.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						typeCheckingMode = "basic",
					},
					venvPath = vim.fn.expand("~/.virtualenvs"),
				},
			},
			before_init = function(_, config)
				local venv_paths = {
					vim.fn.getcwd() .. "/.venv/bin/python",
					vim.fn.getcwd() .. "/venv/bin/python",
					vim.fn.getcwd() .. "/env/bin/python",
				}
				for _, path in ipairs(venv_paths) do
					if vim.fn.filereadable(path) == 1 then
						config.settings.python.pythonPath = path
						break
					end
				end
				if not config.settings.python.pythonPath then
					config.settings.python.pythonPath = vim.fn.exepath("python3")
						or vim.fn.exepath("python")
						or "python"
				end
				print("Python path: " .. config.settings.python.pythonPath)
			end,
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
				source = "always",
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
