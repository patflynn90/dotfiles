return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    init = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "Seelct outer part of a function" },
                        ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
                        ["ao"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
                        ["io"] = { query = "@comment.inner", desc = "Select inner part of a comment" },
                        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                    },
                    selection_modes = {
                        ["@parameter.outer"] = "v",
                        ["@funciton.outer"] = "V",
                        ["@class.outer"] = "<c-v>",
                    },
                    include_surrounding_whitespace = true,
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
                    },
                    swap_previous = {
                        ["<leader>A"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
                    },
                },
            },
        })
    end,
}
