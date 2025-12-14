return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Habilitar file watching para que el LSP detecte cambios en archivos automáticamente
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

		-- Aplicar capabilities a todos los servidores LSP
		vim.lsp.config('*', {
			capabilities = capabilities,
		})

		vim.lsp.enable({
			"tsgo",
			"angularls",
			"astro",
			"docker_compose_language_server",
			"docker_language_server",
			"dockerls",
			"graphql",
			"html",
			"jsonls",
			"lua_ls",
			"nginx_language_server",
			"oxlint",
			"postgres_lsp",
			"prismals",
			"rust_analyzer",
			"tailwindcss",
			"biome",
			"yamlls",
			"somesass_ls",
			"cssls",
			"cssmodules_ls",
			"css_variables",
			"emmet_language_server",
			"eslint",
		})
	end
}
