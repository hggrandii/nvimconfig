return {
	"ThePrimeagen/harpoon",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local harpoon = require("harpoon")
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		harpoon.setup()

		local keymap = vim.keymap

		keymap.set("n", "<leader>a", function()
			mark.add_file()
		end, { desc = "Add file to Harpoon" })

		keymap.set("n", "<C-e>", function()
			ui.toggle_quick_menu()
		end, { desc = "Toggle Harpoon Quick Menu" })

		keymap.set("n", "<C-h>", function()
			ui.nav_file(1)
		end, { desc = "Navigate to Harpoon file 1" })

		keymap.set("n", "<C-t>", function()
			ui.nav_file(2)
		end, { desc = "Navigate to Harpoon file 2" })

		keymap.set("n", "<C-n>", function()
			ui.nav_file(3)
		end, { desc = "Navigate to Harpoon file 3" })

		keymap.set("n", "<C-s>", function()
			ui.nav_file(4)
		end, { desc = "Navigate to Harpoon file 4" })

		keymap.set("n", "<C-S-P>", function()
			ui.nav_prev()
		end, { desc = "Navigate to previous Harpoon buffer" })

		keymap.set("n", "<C-S-N>", function()
			ui.nav_next()
		end, { desc = "Navigate to next Harpoon buffer" })

		keymap.set("n", "<C-d>", function()
			local current_buf = vim.api.nvim_get_current_buf()
			local current_file = vim.api.nvim_buf_get_name(current_buf)

			mark.rm_file(current_file)

			ui.toggle_quick_menu()
			ui.toggle_quick_menu()

			print("Removed from Harpoon: " .. current_file)
		end, { desc = "Remove the current file from Harpoon" })
	end,
}
