return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	config = function()
		require("lsp_lines").setup()
		vim.diagnostic.config({ virtual_lines = true })
		vim.keymap.set("n", "<space>l", function()
			vim.diagnostic.open_float()
		end, { desc = "Open diagnostic float" })
	end
}
