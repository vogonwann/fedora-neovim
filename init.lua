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
        fn.system({
            "git", "clone", "--depth", "1",
            "https://github.com/wbthomason/packer.nvim", install_path,
        })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
    -- Packer
    use("wbthomason/packer.nvim")

    -- UI & Utils
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

    -- Dashboard
    use("goolord/alpha-nvim")

    -- AI
    use("zbirenbaum/copilot.lua")

    -- LSP & Autocomplete
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

    use({
    "folke/noice.nvim",
    	requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    })
    use("folke/zen-mode.nvim")
    use("folke/twilight.nvim")

    if packer_bootstrap then
        require("packer").sync()
    end
end)

------------------------------------------------------------
-- General UI
------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"

vim.cmd("colorscheme gruvbox")
vim.notify = require("notify")

------------------------------------------------------------
-- Telescope
------------------------------------------------------------
require("telescope").setup({})
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
require("nvim-treesitter.configs").setup { highlight = { enable = true } }

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
require("mason-lspconfig").setup {}

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Volar
lspconfig.volar.setup({
    capabilities = capabilities,
})

-- Tailwind
lspconfig.tailwindcss.setup({
    capabilities = capabilities,
})

-- .NET / C#
local cs_capabilities = vim.lsp.protocol.make_client_capabilities()
cs_capabilities.textDocument.completion = {
    completionItem = {
        snippetSupport = true,
    },
    contextSupport = true,
}
cs_capabilities.textDocument.completion.triggerCharacters = { ".", ":", "<", '"', "'", "/", "@", " " }
cs_capabilities = require("cmp_nvim_lsp").default_capabilities(cs_capabilities)

lspconfig.csharp_ls.setup({
    cmd = { vim.fn.expand("~/.dotnet/tools/csharp-ls") },
    capabilities = cs_capabilities,
})

------------------------------------------------------------
-- CMP (Autocomplete + Snippets + Copilot)
------------------------------------------------------------
require("tailwindcss-colorizer-cmp").setup({ color_square_width = 2 })

local cmp = require("cmp")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    completion = { autocomplete = { "TextChanged" }, keyword_length = 3 },
    snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },

    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Esc>"] = cmp.mapping.close(),
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }),

    formatting = { format = require("tailwindcss-colorizer-cmp").formatter },
})

------------------------------------------------------------
-- Null-ls (Prettier + CSharpier)
------------------------------------------------------------
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({ filetypes = { "javascript", "typescript", "vue", "json" } }),
        null_ls.builtins.formatting.csharpier,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
            })
        end
    end,
})

------------------------------------------------------------
-- Copilot
------------------------------------------------------------
require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept = "<Tab>",
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<C-/>",
        },
    },
    panel = { enabled = false },
})

------------------------------------------------------------
-- Alpha (Dashboard)
------------------------------------------------------------
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
"      БУРКЕ Ultra AI Neovim Edition 🚀",
" =====================================",
"",
}

dashboard.section.buttons.val = {
    dashboard.button("e", "📄 New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "🔍 Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "🕑 Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("q", "❌ Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.config)

------------------------------------------------------------
-- Noice (Cmd popup + UI)
------------------------------------------------------------
require("noice").setup({
    cmdline = {
        enabled = true,
        view = "cmdline_popup", -- adds popup style command line
        format = {
            cmdline = { icon = "" },
            search_down = { icon = "🔍 " },
            search_up = { icon = "🔍 " },
        },
    },
    messages = {
        enabled = true,
    },
    popupmenu = {
        enabled = true,
    },
    notify = {
        enabled = true,
    },
    lsp = {
        progress = { enabled = true },
        signature = { enabled = true },
        hover = { enabled = true },
    },
})

vim.keymap.set("n", "<leader>nl", function()
    require("noice").cmd("last")
end, { desc = "Noice Last Message" })

------------------------------------------------------------
-- Notify (pretty notifications)
------------------------------------------------------------
vim.notify = require("notify")
require("notify").setup({
    background_colour = "#000000",
})

------------------------------------------------------------
-- Zen Mode + Twilight (Focus Mode)
------------------------------------------------------------

require("twilight").setup({
    dimming = {
        alpha = 0.25, -- how much to dim inactive portions of the code
    },
    context = 10, -- show 10 lines around the current line
})

require("zen-mode").setup({
    window = {
        backdrop = 0.95, -- dim the rest of the editor
        width = 80,
        height = 1,
        options = {
            number = false,
            relativenumber = false,
        },
    },
    plugins = {
        twilight = { enabled = true }, -- automatically enable twilight when zen mode opens
        gitsigns = { enabled = false },
        tmux = { enabled = false },
    },
    on_open = function()
        vim.cmd("echo '🧘 Focus time started...'")
    end,
    on_close = function()
        vim.cmd("echo '🚀 Focus mode ended.'")
    end,
})

vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { noremap = true, silent = true })

------------------------------------------------------------
-- Hot reload init.lua
------------------------------------------------------------
vim.cmd([[
augroup reload_vimrc
  autocmd!
  autocmd BufWritePost init.lua source <afile> | PackerCompile
augroup END
]])
