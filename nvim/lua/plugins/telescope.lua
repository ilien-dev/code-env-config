return {
	'nvim-telescope/telescope.nvim', 
	init = function()
		vim.g.augment_workspace_folders = {
			"~/.myconfig/nvim",
			"~/.myconfig/tmux",
			"~/.config/fish"
		}
	end,
	tag = 'v0.2.0',
	dependencies = { 
		'nvim-lua/plenary.nvim',
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
		},
		{
            "nvim-telescope/telescope-live-grep-args.nvim",
            version = "^1.0.0",
        },
	},
	config = function()
        local fb_actions = require("telescope").extensions.file_browser.actions
		local lga_actions = require("telescope-live-grep-args.actions")

		require('telescope').setup {
			pickers = {
				find_files = {
					theme = "ivy"
				},
				live_grep = {
					theme = "ivy",
				},
				grep_string = {
					theme = "ivy"
				},
			},
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					"dist",
					"build",
					"vendor",
					"tmp",
					"out",
					"public",
					"target",
					"coverage",
					"doc",
					"docs",
					"test",
					"tests",
					".idea"
				}
			},
			extensions = {
				file_browser = {
					hijack_netrw = true,
					theme = "ivy",
					mappings = {
						["i"] = {
							["<A-c>"] = fb_actions.create,         -- Alt+c  create (file or folder)
							["<A-r>"] = fb_actions.rename,         -- Alt+r  rename
							["<A-d>"] = fb_actions.remove,         -- Alt+d  delete
							["<C-o>"] = fb_actions.copy,           -- copy
							["<C-p>"] = fb_actions.move,           -- move
							["<C-g>"] = fb_actions.goto_parent_dir, -- goto parent directory
							["<C-w>"] = fb_actions.goto_cwd,        -- goto current working directory
						},
						["n"] = {
							["c"] = fb_actions.create,             -- create
							["r"] = fb_actions.rename,             -- rename
							["d"] = fb_actions.remove,             -- delete
							["y"] = fb_actions.copy,               -- copy
							["m"] = fb_actions.move,               -- move
							["g"] = fb_actions.goto_parent_dir,    -- goto parent directory
							["w"] = fb_actions.goto_cwd,           -- goto current working directory
						},
					},
				},
				extensions = {
                      fzf = {
                        fuzzy = true,
                        override_file_sorter = true,
                        override_generic_sorter = true,
                        case_mode = "smart_case",
                      },
                },
                live_grep_args = {
                      auto_quoting = true, -- enable/disable auto-quoting
                      -- define mappings, e.g.
                      mappings = { -- extend mappings
                        i = {
                          ["<C-k>"] = lga_actions.quote_prompt(),
                          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                          -- freeze the current list and start a fuzzy search in the frozen list
                          ["<C-space>"] = lga_actions.to_fuzzy_refine,
                        },
                      },
                      -- ... also accepts theme settings, for example:
                      -- theme = "dropdown", -- use dropdown theme
                      -- theme = { }, -- use own theme spec
                      -- layout_config = { mirror=true }, -- mirror preview pane
                }
			},
		}

		local telescope = require('telescope')

		telescope.load_extension('fzf') -- Temporarily disabled for testing
		telescope.load_extension('file_browser')
		telescope.load_extension("live_grep_args")

		local builtin = require('telescope.builtin')

	 	local load_file_browser = function()
			local root_cwd = vim.fn.getcwd()
			telescope.extensions.file_browser.file_browser({
				path = "%:p:h", -- start in current file's dir
				respect_gitignore = false,
				hidden = true,
				cwd = root_cwd,
				attach_mappings = function(prompt_bufnr, map)
					local actions = require("telescope.actions")

					map("i", "<CR>", actions.select_default)
					map("n", "<CR>", actions.select_default)
					return true
				end,
			})
		end

		-- vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Help" })
		vim.keymap.set("n", "<space>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<space>fd", load_file_browser, { desc = "File browser" })

		vim.keymap.set("n", "<space>fs", function()
          local opts = require("telescope.themes").get_ivy()
          opts.default_text = '"" -F'
          opts.initial_mode = "normal"
          require("telescope").extensions.live_grep_args.live_grep_args(opts)
        end, { desc = "Search string/characters (livegrep)" })
        vim.keymap.set("n", "<space>fc", function()
          local opts = require("telescope.themes").get_ivy()
          opts.initial_mode = "normal"
          require("telescope-live-grep-args.shortcuts").grep_word_under_cursor(opts)
        end, { desc = "Grep string" })
	end
}

