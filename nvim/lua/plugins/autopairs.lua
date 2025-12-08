return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
	disabled = true,
    config = function()
        require('nvim-autopairs').setup({
            disable_filetype = { "TelescopePrompt", "vim" },
        })
    end
}
