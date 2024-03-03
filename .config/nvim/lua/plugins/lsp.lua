return {
    -- Manson
    { 'williamboman/mason.nvim', config = true },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
    },

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = function()
            local lsp_zero = require('lsp-zero')

            lsp_zero.on_attach(function(_, bufnr)
                local opts = { buffer = bufnr }

                lsp_zero.default_keymaps(opts)

                vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
                    vim.lsp.buf.format({ async = false })
                end, opts)
            end)

            lsp_zero.format_on_save()
            lsp_zero.set_sign_icons({
                error = '✘',
                warn = '▲',
                hint = '⚑',
                info = '»',
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'rust_analyzer',
                    'eslint',
                    'lua_ls',
                    'tsserver',
                },
                handlers = {
                    lsp_zero.default_setup,

                    -- Configure Lua to include the current workspace.
                    ['lua_ls'] = function()
                        local opts = lsp_zero.nvim_lua_ls()

                        require('lspconfig').lua_ls.setup(opts)
                    end
                }
            })
        end,
        dependencies = {
            -- LSP support
            { 'neovim/nvim-lspconfig' },

            -- Manson managament of LSP servers and configs
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
    },

    -- Auto-completion
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'cmdline' },
                    { name = 'luasnip' },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    -- `Enter` key to confirm completion
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

                    -- Ctrl+Space to trigger completion menu
                    ['<C-Space>'] = cmp.mapping.complete(),

                    -- Navigate between snippet placeholder
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

                    -- Scroll up and down in the completion documentation
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                })
            })
        end,
        dependencies = {
            { 'VonHeikemen/lsp-zero.nvim' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Lua snip
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' }
        },
    }
}
