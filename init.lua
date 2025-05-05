------------------------------------------------------------
-- Leader Key
------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>o", ":NvimTreeFocus<CR>")

------------------------------------------------------------
-- Plugins
------------------------------------------------------------
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use("ellisonleao/gruvbox.nvim")
    use("nvim-lua/plenary.nvim")
    use("nvim-telescope/telescope.nvim")
    use("lewis6991/gitsigns.nvim")
    use("nvim-treesitter/nvim-treesitter")
    use("numToStr/Comment.nvim")
    use("nvim-lualine/lualine.nvim")
    use("akinsho/bufferline.nvim")
    use("nvim-tree/nvim-tree.lua")
    use("nvim-tree/nvim-web-devicons")
    use("rcarriga/nvim-notify")
    use("folke/todo-comments.nvim")
    use("folke/which-key.nvim")
    use("ThePrimeagen/harpoon")
    use("kdheepak/lazygit.nvim")
    use("folke/trouble.nvim")
    use("MunifTanjim/nui.nvim")
    use("goolord/alpha-nvim")
    use("zbirenbaum/copilot.lua")
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("onsails/lspkind.nvim")
    use("roobert/tailwindcss-colorizer-cmp.nvim")
    use("nvimtools/none-ls.nvim")
    use({ "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } })
    use("folke/zen-mode.nvim")
    use("folke/twilight.nvim")
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("jay-babu/mason-nvim-dap.nvim")
    use("nvim-neotest/nvim-nio")
    use("theHamsta/nvim-dap-virtual-text")

    if packer_bootstrap then require("packer").sync() end
end)

------------------------------------------------------------
-- UI
------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.cmd("colorscheme gruvbox")

------------------------------------------------------------
-- Telescope
------------------------------------------------------------
require("telescope").setup({})
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

------------------------------------------------------------
-- Comment
------------------------------------------------------------
require("Comment").setup()

------------------------------------------------------------
-- Lualine
------------------------------------------------------------
require("lualine").setup()

------------------------------------------------------------
-- Bufferline
------------------------------------------------------------
require("bufferline").setup()

------------------------------------------------------------
-- NvimTree
------------------------------------------------------------
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

------------------------------------------------------------
-- Harpoon
------------------------------------------------------------
require("harpoon").setup()
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file)
vim.keymap.set("n", "<leader>h", require("harpoon.ui").toggle_quick_menu)

------------------------------------------------------------
-- LazyGit
------------------------------------------------------------
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>")

------------------------------------------------------------
-- Trouble
------------------------------------------------------------
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")

------------------------------------------------------------
-- Mason + LSP
------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup()
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.volar.setup({ capabilities = capabilities })
lspconfig.tailwindcss.setup({ capabilities = capabilities })

local cs_capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.csharp_ls.setup({ cmd = { vim.fn.expand("~/.dotnet/tools/csharp-ls") }, capabilities = cs_capabilities })

------------------------------------------------------------
-- CMP + Copilot
------------------------------------------------------------
require("tailwindcss-colorizer-cmp").setup()
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then require("copilot.suggestion").accept()
            elseif cmp.visible() then cmp.select_next_item()
            else fallback() end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }),
    formatting = { format = require("tailwindcss-colorizer-cmp").formatter },
})

require("copilot").setup({ suggestion = { enabled = true, auto_trigger = true } })

------------------------------------------------------------
-- Null-ls
------------------------------------------------------------
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.csharpier,
    },
})

------------------------------------------------------------
-- Zen + Twilight
------------------------------------------------------------
require("zen-mode").setup({})
require("twilight").setup({})

vim.keymap.set("n", "<leader>z", ":ZenMode<CR>")

------------------------------------------------------------
-- Alpha Dashboard
------------------------------------------------------------
require("alpha").setup(require("alpha.themes.dashboard").config)

------------------------------------------------------------
-- Noice
------------------------------------------------------------
require("noice").setup({})
vim.notify = require("notify")

------------------------------------------------------------
-- DAP Virtual Text (pre DAP)
------------------------------------------------------------
vim.g.dap_virtual_text = true
require("nvim-dap-virtual-text").setup({ enabled = true })

------------------------------------------------------------
-- DAP
------------------------------------------------------------
local dap = require("dap")
local dapui = require("dapui")

dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.expand("~/.local/bin/netcoredbg"),
    args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net7.0/', 'file')
        end,
    },
}

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

------------------------------------------------------------
-- DAP Keymaps
------------------------------------------------------------
vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end)
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end)
vim.keymap.set("n", "<leader>du", function() dapui.toggle() end)

------------------------------------------------------------
-- Reload init.lua on save
------------------------------------------------------------
vim.cmd([[
augroup reload_vimrc
  autocmd!
  autocmd BufWritePost init.lua source <afile> | PackerCompile
augroup END
]])

