return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}

-- return {
--   {
--     "rebelot/kanagawa.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("kanagawa").setup({
--         transparent = true,
--         theme = "wave",
--       })
--       vim.cmd.colorscheme("kanagawa")
--     end,
--   },
-- }
--
--
--
-- return {
--   {
--     "catppuccin/nvim",
--     lazy = false,
--     name = "catppuccin",
--     priority = 1000,
--     config = function()
--       require("catppuccin").setup({
--         transparent_background = true,
--       })
--       vim.cmd.colorscheme("catppuccin-mocha")
--     end,
--   },
-- }
