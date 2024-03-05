return {
    -- -------------------------------------------------------------------------
    -- Lua line configuration
    -- -------------------------------------------------------------------------
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = 'VeryLazy',
        config = function()
            require('lualine').setup({
                extensions = {
                    'lazy',
                },
                options = {
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = '' },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = {
                        'mode',
                    },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                        },
                    },
                    lualine_x = { 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
            })
        end
    },

    -- -------------------------------------------------------------------------
    -- File status
    -- -------------------------------------------------------------------------
    {
        'b0o/incline.nvim',
        event = 'VeryLazy',
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

    -- -------------------------------------------------------------------------
    -- Command suggestions
    -- -------------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 1000
        end,
    },


    -- -------------------------------------------------------------------------
    -- File tree
    -- -------------------------------------------------------------------------
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        config = true,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        keys = {
            { '<leader>tt', '<cmd>NvimTreeToggle<CR>',  desc = '[T]oggle [T]ree' },
            { '<leader>tf', '<cmd>NvimTreeFocus<CR>',   desc = '[T]ree [F]ocus', },
            { '<leader>tr', '<cmd>NvimTreeRefresh<CR>', desc = '[T]ree [R]efresh' },
        },
    },
}
