return {
  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("template-string").setup({
        -- filetypes where it should work
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "html",
          "python",
          "cs",
        },
        jsx_brackets = true,         -- in JSX props: value="foo ${bar}" -> value={`foo ${bar}`}
        remove_template_string = true, -- if true, it turns backticks → quotes when there’s no ${}
        restore_quotes = {
          normal = [[']],            -- quote to restore in normal strings
          jsx    = [["]],            -- quote to restore in JSX attributes
        },
      })
    end,
  },
}

