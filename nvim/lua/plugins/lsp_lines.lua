return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_lines = true })
        vim.keymap.set("n", "<space>l", function()
            vim.diagnostic.open_float()
        end, { desc = "Open diagnostic float" })

        -- Refresh all open buffers when saving any file to update LSP diagnostics
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("LspLinesRefresh", { clear = true }),
            callback = function()
                local current_buf = vim.api.nvim_get_current_buf()

                vim.defer_fn(function()
                    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                        if bufnr ~= current_buf and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
                            local clients = vim.lsp.get_clients({ bufnr = bufnr })
                            if #clients > 0 then
                                -- Clear existing diagnostics first
                                vim.diagnostic.reset(nil, bufnr)

                                for _, client in ipairs(clients) do
                                    -- Request fresh diagnostics from LSP
                                    local params = {
                                        textDocument = vim.lsp.util.make_text_document_params(bufnr),
                                    }
                                    client.request("textDocument/diagnostic", params, function(err, result)
                                        if result and result.items then
                                            vim.lsp.diagnostic.on_publish_diagnostics(nil, {
                                                uri = vim.uri_from_bufnr(bufnr),
                                                diagnostics = result.items,
                                            }, { client_id = client.id, bufnr = bufnr })
                                        end
                                    end, bufnr)
                                end
                            end
                        end
                    end
                end, 500)
            end,
        })
    end
}
