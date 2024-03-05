return {
    -- File search
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
        keys = function()
            local builtin = require('telescope.builtin')

            return {
                { '<leader>sh',       builtin.help_tags,   { desc = '[S]earch [H]elp' }, },
                { '<leader>sk',       builtin.keymaps,     { desc = '[S]earch [K]eymaps' }, },
                { '<leader>sf',       builtin.find_files,  { desc = '[S]earch [F]iles' }, },
                { '<leader>ss',       builtin.builtin,     { desc = '[S]earch [S]elect Telescope' }, },
                { '<leader>sw',       builtin.grep_string, { desc = '[S]earch current [W]ord' }, },
                { '<leader>sg',       builtin.live_grep,   { desc = '[S]earch by [G]rep' }, },
                { '<leader>sd',       builtin.diagnostics, { desc = '[S]earch [D]iagnostics' }, },
                { '<leader>sr',       builtin.resume,      { desc = '[S]earch [R]esume' }, },
                { '<leader>s.',       builtin.oldfiles,    { desc = '[S]earch Recent Files ("." for repeat)' }, },
                { '<leader><leader>', builtin.buffers,     { desc = '[ ] Find existing buffers' }, },
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
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        config = true,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        keys = {
            { '<leader>tt', '<cmd>NvimTreeToggle<CR>',  'Toggle the file tree' },
            { '<leader>tf', '<cmd>NvimTreeFocus<CR>',   'Focus on the file tree', },
            { '<leader>tr', '<cmd>NvimTreeRefresh<CR>', 'Refresh the file tree' },
        },
    },

    -- Tree Sitter
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

    -- Status-line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            extensions = {
                'lazy',
            },
            options = {
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                globalstatus = true,
            }
        }
    },

    -- Floating file name
    {
        'b0o/incline.nvim',
        opts = {
            window = {
                padding = 0,
                margin = {
                    horizontal = 0,
                    vertical = 0,
                },
            },
            render = function(props)
                local dev_icons = require('nvim-web-devicons')

                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                if filename == '' then
                    filename = '[No Name]'
                end

                local ft_icon, _ = dev_icons.get_icon_color(filename)
                local modified = vim.bo[props.buf].modified

                return {
                    ft_icon and { ' ', ft_icon } or '',
                    ' ',
                    { filename, gui = modified and 'italic' or '' },
                    ' ',
                }
            end,
        },
    },

    -- Command suggestions
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 1000
        end,
        config = true,
    },

    -- Comment code using "gc"
    { 'numToStr/Comment.nvim', opts = {} },
}
