return {
    -- -------------------------------------------------------------------------
    -- File search
    -- -------------------------------------------------------------------------
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
        keys = function()
            local builtin = require('telescope.builtin')

            return {
                { '<leader>sh',       builtin.help_tags,   desc = '[S]earch [H]elp' },
                { '<leader>sk',       builtin.keymaps,     desc = '[S]earch [K]eymaps' },
                { '<leader>sf',       builtin.find_files,  desc = '[S]earch [F]iles' },
                { '<leader>ss',       builtin.builtin,     desc = '[S]earch [S]elect Telescope' },
                { '<leader>sw',       builtin.grep_string, desc = '[S]earch current [W]ord' },
                { '<leader>sg',       builtin.live_grep,   desc = '[S]earch by [G]rep' },
                { '<leader>sd',       builtin.diagnostics, desc = '[S]earch [D]iagnostics' },
                { '<leader>sr',       builtin.resume,      desc = '[S]earch [R]esume' },
                { '<leader>s.',       builtin.oldfiles,    desc = '[S]earch Recent Files ("." for repeat)' },
                { '<leader><leader>', builtin.buffers,     desc = '[ ] Find existing buffers' },
            }
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = function()
            local harpoon = require('harpoon')

            local function toggle_quick_menu()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end

            return {
                { '<C-e>',     toggle_quick_menu },
                { '<C-S-P>',   function() harpoon:list():prev() end },
                { '<C-S-N>',   function() harpoon:list():next() end },
                { '<leader>a', function() harpoon:list():append() end },
                { '<C-h>',     function() harpoon:list():select(1) end },
                { '<C-j>',     function() harpoon:list():select(2) end },
                { '<C-k>',     function() harpoon:list():select(3) end },
                { '<C-l>',     function() harpoon:list():select(4) end },
            }
        end
    },

    -- -------------------------------------------------------------------------
    -- Tree Sitter
    -- -------------------------------------------------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "javascript",
                    "html",
                    "css",
                    "rust",
                },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    -- Comment code using "gc"
    { 'numToStr/Comment.nvim', opts = {} },

    -- Surround text
    --{
    --    "kylechui/nvim-surround",
    --    version = "main",
    --    event = "VeryLazy",
    --    opts = {}
    --}
}
