return {
	'augmentcode/augment.vim',
	config = function()
		vim.g.augment_disable_completions_filetypes = {
			"TelescopePrompt",
			"TelescopeResults",
		}
		vim.keymap.set({"n", "v"}, "<space>ac", "<cmd>Augment chat<CR>", {
			silent = true,
			desc = "Augment: chat",
		})
		vim.keymap.set("n", "<space>an", "<cmd>Augment chat-new<CR>", {
			silent = true,
			desc = "Augment: new chat",
		})
		vim.keymap.set("n", "<space>at", "<cmd>Augment chat-toggle<CR>", {
			silent = true,
			desc = "Augment: toggle chat",
		})
		vim.keymap.set("n", "<space>as", "<cmd>Augment status<CR>", {
			silent = true,
			desc = "Augment: status",
		})
		vim.keymap.set("n", "<space>ai", "<cmd>Augment signin<CR>", {
			silent = true,
			desc = "Augment: signin",
		})
	end
}
