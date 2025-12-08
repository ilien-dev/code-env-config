return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,

    -- Inline blame (highly recommended by community)
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 200,
      virt_text_pos = "eol",
    },

    -- Gitsigns performance tuning (recommended for large repos)
    watch_gitdir = { interval = 1000 },
    update_debounce = 100,

    -- Keymaps following official gitsigns.nvim patterns
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      map("n", "]]", function() gs.next_hunk() end, { desc = "Next Git Hunk" })
      map("n", "<space>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
	  map("n", "<space>hr", gs.reset_hunk, { desc = "Reset Hunk" })
      map("n", "[[", function() gs.prev_hunk() end, { desc = "Prev Git Hunk" })

      -- Actions
      map("n", "<space>hp", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<space>hb", gs.blame_line, { desc = "Blame Line" })

      -- Whole buffer
      map("n", "<space>hR", gs.reset_buffer, { desc = "Reset Buffer" })
    end,
  },
}

