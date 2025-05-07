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
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
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
    use({
        "mason-org/mason-lspconfig.nvim",
        tag = "v2.0.0"
    })
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
    use("kosayoda/nvim-lightbulb")
    use("stevearc/dressing.nvim")
    use("b0o/schemastore.nvim")
    use("someone-stole-my-name/yaml-companion.nvim")
    use({ "akinsho/toggleterm.nvim", tag = "*" })
    if packer_bootstrap then require("packer").sync() end
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
-- LSP Lightbulb
------------------------------------------------------------
vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])

-------------------------------------------------------------
-- ToggleTerm
-------------------------------------------------------------
require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    direction = "float", -- или "horizontal", "vertical"
    float_opts = {
        border = "curved",
    },
})



------------------------------------------------------------
-- Mason + LSP (Burke Full Manual Control)
------------------------------------------------------------
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "yamlls" },
    automatic_installation = true,
    automatic_setup = true,
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Manual setups
lspconfig.volar.setup({ capabilities = capabilities })
lspconfig.tailwindcss.setup({ capabilities = capabilities })
lspconfig.csharp_ls.setup({
    cmd = { vim.fn.expand("~/.dotnet/tools/csharp-ls") },
    capabilities = capabilities,
})
lspconfig.rust_analyzer.setup({ capabilities = capabilities })
lspconfig.gopls.setup({ capabilities = capabilities })

-- YAML special case → moraš koristiti on_attach
lspconfig.yamlls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            yaml = {
                schemas = require("schemastore").yaml.schemas(),
                validate = true,
                hover = true,
                completion = true,
            },
        })
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end,
})

------------------------------------------------------------
-- LSP Diagnostics virtual text
------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- Marker on the left of the line (can be changed to → or  or * etc.)
    },
    signs = true,
    underline = true,
    update_in_insert = false,
})

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
require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        progress = {
            enabled = true
        },
        signature = {
            enabled = true
        },
        hover = {
            enabled = true
        },
        message = {
            enabled = true
        }
    },
    presets = {
        command_palette = true,
        lsp_doc_border = true,
    },
})

vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers["textDocument/codeAction"], {
    border = "rounded"
})

------------------------------------------------------------
-- Dressing
------------------------------------------------------------
require("dressing").setup()

------------------------------------------------------------
-- DAP + DAP UI
------------------------------------------------------------
local dap = require("dap")
local dapui = require("dapui")

-- Rust DAP (codelldb)
local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
    }
}
dap.configurations.rust = {
    {
        name = "Launch Rust",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

-- Go DAP (delve)
dap.adapters.go = function(callback, config)
    local handle
    local pid_or_err
    local port = 38697
    handle, pid_or_err = vim.loop.spawn("dlv", {
        args = { "dap", "-l", "127.0.0.1:" .. port },
        detached = true
    }, function(code)
        handle:close()
    end)
    vim.defer_fn(function()
        callback({ type = "server", host = "127.0.0.1", port = port })
    end, 100)
end
dap.configurations.go = {
    {
        type = "go",
        name = "Debug Go",
        request = "launch",
        program = "${file}",
    },
}

-- C# DAP
dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.expand("~/.local/bin/netcoredbg"),
    args = { '--interpreter=vscode' }
}
dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch C#",
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
-- Burke Dev Mode - DAP Shortcuts per language
------------------------------------------------------------

-- Rust Debug
vim.keymap.set("n", "<leader>rr", function()
    require("dap").run(dap.configurations.rust[1])
end, { desc = "Rust Debug Start" })

-- Go Debug
vim.keymap.set("n", "<leader>gr", function()
    require("dap").run(dap.configurations.go[1])
end, { desc = "Go Debug Start" })

-- C# Debug
vim.keymap.set("n", "<leader>cr", function()
    require("dap").run(dap.configurations.cs[1])
end, { desc = "C# Debug Start" })

vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, { desc = "LSP Signature Help" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP Format" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "LSP Diagnostic Float" })
vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "LSP Declaration" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Docs" })
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "LSP References" })
vim.keymap.set("n", "<leader>lS", vim.lsp.buf.signature_help, { desc = "LSP Signature Help" })
vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, { desc = "LSP Workspace Symbol" })

------------------------------------------------------------
-- LSP Format on Save
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

------------------------------------------------------------
-- Reload init.lua on save
------------------------------------------------------------
vim.cmd([[
augroup reload_vimrc
  autocmd!
  autocmd BufWritePost init.lua source <afile> | PackerCompile
augroup END
]])

