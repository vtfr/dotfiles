-- Copy pasting helpers
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without copying' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'yank into the system\'s clipboard' })

-- Quality of life
-- vim.keymap.set('n', 'q', '<nop>')
vim.keymap.set('i', '<C-c>', '<Esc>')

-- Replace in file
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Replace in file' })

-- LSP
vim.keymap.set(
    'n',
    '<leader>f',
    function() vim.lsp.buf.format() end,
    {
        desc = 'Format file'
    })

-- Neovide specific configuration
if vim.g.neovide then
    -- Toggle fullscreen
    vim.keymap.set('n', '<F11>', function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, {
        desc = 'Toggle neovide fullscreen',
    })
end

