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
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							local buf_set_keymap = vim.api.nvim_buf_set_keymap
							local opts = { noremap = true, silent = true }

							-- Key mappings
							buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
							buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
							buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
							buf_set_keymap(bufnr, "n", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
							buf_set_keymap(
								bufnr,
								"n",
								"<space>wa",
								"<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
								opts
							)
							buf_set_keymap(
								bufnr,
								"n",
								"<space>wr",
								"<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
								opts
							)
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
							buf_set_keymap(bufnr, "n", "<space>e", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
							buf_set_keymap(bufnr, "n", "<æ", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
							buf_set_keymap(bufnr, "n", "<ð", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
							buf_set_keymap(bufnr, "n", "<space>q", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts)
							buf_set_keymap(bufnr, "n", "<space>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)

							-- Debugging: Print buffer number and client name
							print("LSP attached to buffer", bufnr, "with client", client.name)
						end,
					})
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
			},
		})

		-- Setup Flutter Tools
		require("flutter-tools").setup({
			lsp = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					local buf_set_keymap = vim.api.nvim_buf_set_keymap
					local opts = { noremap = true, silent = true }

					-- Key mappings for Dart/Flutter
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
					buf_set_keymap(bufnr, "n", "<space>e", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
					buf_set_keymap(bufnr, "n", "<æ", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
					buf_set_keymap(bufnr, "n", "<ð", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
					buf_set_keymap(bufnr, "n", "<space>q", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts)
					buf_set_keymap(bufnr, "n", "<space>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)

					-- Debugging: Print buffer number and client name
					print("LSP attached to buffer", bufnr, "with client", client.name)
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
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
		})
	end,
}
