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
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })


      local conf = require("telescope.config").values

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in pairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        local function delete_harpoon_entry(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          if selection then
            local list = harpoon:list()
            -- Encontrar y eliminar el item usando remove() que mantiene la lista compacta
            for _, item in pairs(list.items) do
              if item.value == selection.value then
                list:remove(item)
                break
              end
            end
            require("telescope.actions").close(prompt_bufnr)
            toggle_telescope(harpoon:list())
          end
        end

        local function delete_all_harpoon_entries(prompt_bufnr)
          local list = harpoon:list()
          list:clear()
          require("telescope.actions").close(prompt_bufnr)
          vim.notify("Harpoon list cleared", vim.log.levels.INFO)
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
			map("n", "dD", delete_all_harpoon_entries)
			return true
		  end,
        }):find()
      end

      vim.keymap.set("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open Harpoon (Telescope)" })
	  vim.keymap.set("n", "<space>t", function() harpoon:list():add() end)
	  vim.keymap.set("n", "<space>T", function()
	    harpoon:list():clear()
	    vim.notify("Harpoon list cleared", vim.log.levels.INFO)
	  end, { desc = "Clear all Harpoon marks" })

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
