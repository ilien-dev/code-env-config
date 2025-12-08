return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Harpoon 2: use the object and call :setup()
      local harpoon = require("harpoon")
      harpoon:setup({})  -- required by Harpoon 2 docs


      local conf = require("telescope.config").values

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

		local function delete_harpoon_entry(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			if selection then
				for i, item in ipairs(harpoon_files.items) do
					if item.value == selection.value then
						harpoon:list():remove_at(i)
						break
					end
				end
				require("telescope.actions").close(prompt_bufnr)
				toggle_telescope(harpoon:list())
			end
		end

        require("telescope.pickers").new(require("telescope.themes").get_ivy({}), {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
		  attach_mappings = function(prompt_bufnr, map)
			map("i", "<C-d>", delete_harpoon_entry)
			map("n", "dd", delete_harpoon_entry)
			return true
		  end,
        }):find()
      end

      vim.keymap.set("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open Harpoon (Telescope)" })
	  vim.keymap.set("n", "<space>h", function() harpoon:list():add() end)
	  vim.keymap.set("n", "<space>t", function() harpoon:list():add() end)

	  vim.keymap.set("n", "<C-z>", function() harpoon:list():select(1) end)
	  vim.keymap.set("n", "<C-x>", function() harpoon:list():select(2) end)
	  vim.keymap.set("n", "<C-c>", function() harpoon:list():select(3) end)
	  vim.keymap.set("n", "<C-v>", function() harpoon:list():select(4) end)

	  -- Toggle previous & next buffers stored within Harpoon list
	  vim.keymap.set("n", "<C-S-H>", function() harpoon:list():prev() end)
	  vim.keymap.set("n", "<C-S-L>", function() harpoon:list():next() end)
    end,
  },
}
