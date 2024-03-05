return {
    -- -------------------------------------------------------------------------
    -- LSP
    -- -------------------------------------------------------------------------
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = function()
            local lsp_zero = require('lsp-zero')

            lsp_zero.on_attach(function(_, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })

                local function map(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
                end

                -- Telescope integration
                local telescope = require('telescope.builtin')

                map('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
                map('gr', telescope.lsp_references, '[G]oto [R]eferences')
                map('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')
                map('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
                map('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
                map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- Autoformat
                map('<leader>f', function()
                    vim.lsp.buf.format({ async = false })
                end, '[F]ormat file')
            end)

            -- Mason configuration
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'rust_analyzer',
                    'eslint',
                    'lua_ls',
                    'tsserver',
                },
                handlers = {
                    lsp_zero.default_setup,
                },
            })
        end,
        dependencies = {
            -- LSP support
            { 'neovim/nvim-lspconfig' },

            -- Telescope support
            { 'nvim-telescope/telescope.nvim' },

            -- Manson managament of LSP servers and configs
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
    },

    -- -------------------------------------------------------------------------
    -- Auto-completion
    -- -------------------------------------------------------------------------
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
