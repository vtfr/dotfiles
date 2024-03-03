local M = {}

--- @param name "keymaps" | "options" | "autocmd"
function M.load(name)
    local result = pcall(function()
        require('config.' .. name)
    end)

    if not result then
        vim.notify("Failed loading configutation for " .. name, vim.log.levels.ERROR)
    end
end

function M.load_all()
    M.load('options')
    M.load('keymaps')
end

function M.setup()
    M.load_all()

    vim.api.nvim_create_user_command('ReloadConfig', function()
        M.load_all()
    end, {})
end

return M
