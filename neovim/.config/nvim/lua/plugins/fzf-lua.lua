return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "echanovski/mini.icons",
    },
    opts = {
        fzf_bin = "sk",
    },
    keys = {
        {
            "<leader>ff",
            function()
                require("fzf-lua").files()
            end,
            desc = "[F]ind [f]iles in project directory",
        },
        {
            "<leader>fp",
            function()
                require("fzf-lua").live_grep()
            end,
            desc = "[F]ind in project directory via ripgre[p]",
        },
        {
            "<leader>fc",
            function()
                require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "[F]ind Neovim [c]onfig files",
        },
        {
            "<leader>fgb",
            function()
                require("fzf-lua").git_branches()
            end,
            desc = "[F]ind [g]it [b]ranches",
        },
        {
            "<leader>fh",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "[F]ind [h]elp",
        },
        {
            "<leader>fk",
            function()
                require("fzf-lua").keymaps()
            end,
            desc = "[F]ind [k]eymaps",
        },
        {
            "<leader>fw",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[F]ind current [w]ord",
        },
        {
            "<leader>fW",
            function()
                require("fzf-lua").grep_cWORD()
            end,
            desc = "[F]ind current [W]ORD",
        },
        {
            "<leader>fr",
            function()
                require("fzf-lua").resume()
            end,
            desc = "[F]ind [r]esume",
        },
        {
            "<leader>fb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[F]ind [b]uffers",
        },
        {
            "<leader>f/",
            function()
                require("fzf-lua").lgrep_curbuf()
            end,
            desc = "[/] Live grep the current buffer",
        },
        {
            "<leader>fB",
            function()
                require("fzf-lua").builtin()
            end,
            desc = "[F]ind fzf-lua [B]uiltins",
        },
    },
}
