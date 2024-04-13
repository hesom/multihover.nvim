local M = {}

local default_configs = {
    include_diagnostics = true,
    show_titles = false,
    popup_config = {
        focusable = true,
        focus_id = "textDocument/hover",
    },
}

local config

function M.setup(opts)
    opts = opts or {}
    M.set(opts)
end

function M.set(user_config) config = vim.tbl_deep_extend("force", default_configs, user_config) end

function M.hover()
    local params = vim.lsp.util.make_position_params()
    local ___ = "\n----------------------------------------------------------------\n"
    local requestBuf = vim.api.nvim_get_current_buf()
    vim.lsp.buf_request_all(requestBuf, "textDocument/hover", params, function(responses)
        local value = ""

        for idx, response in pairs(responses) do
            local lspName = vim.lsp.get_client_by_id(idx).name
            local result = response.result
            local currBuf = vim.api.nvim_get_current_buf()
            if requestBuf ~= currBuf then return end

            if result and result.contents and result.contents.value then
                if value ~= "" then value = value .. ___ end
                if config.show_titles then value = value .. "\n*" .. lspName .. "*\n" end
                value = value .. result.contents.value
            end
        end

        if config.include_diagnostics then
            local _, row = unpack(vim.fn.getpos("."))
            local lineDiag = vim.diagnostic.get(0, { lnum = row - 1 })
            for _, d in pairs(lineDiag) do
                if d.message then
                    if value ~= "" then value = value .. ___ end
                    value = value .. string.format("*%s %s", d.source, d.message)
                end
            end
        end

        value = value:gsub("\r", "")

        if value ~= "" then
            local contents = vim.split(value, "\n", { trimempty = true })
            return vim.lsp.util.open_floating_preview(contents, "markdown", config.popup_config)
        end
    end)
end

return M
