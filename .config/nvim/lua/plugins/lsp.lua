return {
    -- LSP configuration.
    --
    -- Inspiration:
    --   https://github.com/nvim-lua/kickstart.nvim
    --   https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero.html
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Neodev configuration
            { "folke/neodev.nvim", opts = {} },

            -- Add status updates for LSP
            { 'j-hui/fidget.nvim', opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    -- Configure keybindings for this LSP aware buffer
                    local function map(keys, func, desc)
                        vim.keymap.set('n', keys, func, {
                            buffer = event.buf,
                            desc = 'LSP: ' .. desc
                        })
                    end

                    local function format()
                        vim.lsp.buf.format({ async = true })
                    end

                    local telescope = require('telescope.builtin')

                    map('gd', telescope.lsp_definitions, 'Goto Definition')
                    map('gr', telescope.lsp_references, 'Goto References')
                    map('gI', telescope.lsp_implementations, 'Goto Implementation')
                    map('<leader>D', telescope.lsp_type_definitions, 'Type Definition')
                    map('<leader>ds', telescope.lsp_document_symbols, 'Document Symbols')
                    map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
                    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

                    map('<F2>', vim.lsp.buf.rename, 'Rename')
                    map('<F3>', format, 'Format')
                    map('<F4>', vim.lsp.buf.code_action, 'Code Action')

                    -- Formatting
                    map('<leader>f', format, 'Format')

                    -- Highlights references when hovering over a symbol.
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- Add cmp lnvim lsp capabilits to the default client
            -- capabilities.
            local capabilities = vim.tbl_deep_extend('force',
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities())

            local server = {
                ['lua_ls'] = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
            }

            local function setup_server(server_name)
                -- Load default configurations and extend with
                -- available capabilities
                local opts = vim.tbl_deep_extend('force',
                    {},
                    server[server_name] or {},
                    { capabilitis = capabilities })

                require('lspconfig')[server_name].setup(opts)
            end

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'rust_analyzer',
                    'gopls',
                },
                handlers = {
                    setup_server,
                },
            })
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet engine
            {
                'L3MON4D3/LuaSnip',
                build = 'make install_jsregexp',
            },

            -- Symbols
            'onsails/lspkind.nvim',
            'nvim-tree/nvim-web-devicons',

            -- Snippet sources
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
                -- See more: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#show-devicons-as-kind-field
                formatting = {
                    format = function(entry, vim_item)
                        if vim.tbl_contains({ 'path' }, entry.source.name) then
                            local icon, hl_group = require('nvim-web-devicons')
                                .get_icon(entry:get_completion_item().label)

                            if icon then
                                vim_item.kind = icon
                                vim_item.kind_hl_group = hl_group

                                return vim_item
                            end
                        end

                        local cmp_format = require('lspkind')
                            .cmp_format({ with_text = false })

                        return cmp_format(entry, vim_item)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll docs with CTRL+u and CTRL+d
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),

                    -- Confirm completion with CTRL+y
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                    --['<C-l>'] = cmp.mapping(function()
                    --    if luasnip.expand_or_locally_jumpable() then
                    --        luasnip.expand_or_jump()
                    --    end
                    --end, { 'i', 's' }),

                    --['<C-h>'] = cmp.mapping(function()
                    --    if luasnip.locally_jumpable(-1) then
                    --        luasnip.jump(-1)
                    --    end
                    --end, { 'i', 's' }),
                }),
            })
        end,
    },
}
