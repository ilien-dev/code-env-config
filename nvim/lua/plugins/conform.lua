return {
	{
		-- 1. Core formatter plugin (fast, focused only on formatting)
		"stevearc/conform.nvim",
		event = { "BufWritePre" }, -- 2. Load just before saving files
		cmd = { "ConformInfo" }, -- 3. Command to inspect configured formatters
		opts = {
			-- 4. Decide which formatters run for each filetype
			formatters_by_ft = {
				lua = { "stylua" }, -- uses stylua binary
				javascript = { "prettierd" }, -- or "prettierd"/"prettier" if you prefer
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "jq" },
			},

			-- 5. Global behaviour when you call `conform.format()`
			format_on_save = function(bufnr)
				-- Disable for big files if you want (performance guard)
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
				if ok and stats then
					return nil -- don't format huge files automatically
				end

				return {
					timeout_ms = 1000, -- hard timeout for slow tools
					lsp_fallback = true, -- if no external formatter, use LSP
				}
			end,
		},
		config = function(_, opts)
			-- 6. Actually apply configuration
			local conform = require("conform")
			conform.setup(opts)

			-- 7. Manual keymap: format current buffer (normal + visual mode)
			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				conform.format({
					lsp_fallback = true,
				})
			end, { desc = "[C]ode [F]ormat via conform.nvim" })
		end,
	},
}
