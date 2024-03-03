return {
    -- File search
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = function()
            local builtin = require('telescope.builtin')


            local function telescope(mode, opts)
                if mode == 'files' then
                    mode = 'find_files'
                end

                return function()
                    builtin[mode](opts)
                end
            end

            return {
                { '<leader>pf', telescope('files') },
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
        dependenceis = {
            'nvim-tree/nvim-web-devicons',
        },
        keys = {
            { '<leader>tt', ':NvimTreeToggle<CR>', 'Toggle the file tree'},
            { '<leader>tf', ':NvimTreeFocus<CR>', 'Focus on the file tree', },
            { '<leader>tr', ':NvimTreeRefresh<CR>', 'Refresh the file tree' },
        },
    },

    -- Tree Sitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')

            configs.setup({
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
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    -- Status-line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = {
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
        config = {
            window = {
                padding = 0,
                margin = {
                    horizontal = 0,
                    vertical = 0,
                },
            },
            render = function(props)
                local helpers = require('incline.helpers')
                local dev_icons = require('nvim-web-devicons')

                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                if filename == '' then
                    filename = '[No Name]'
                end

                local ft_icon, ft_color = dev_icons.get_icon_color(filename)
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
}
