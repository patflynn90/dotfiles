return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "Kaiser-Yang/blink-cmp-avante",
        "moyiz/blink-emoji.nvim",
    },
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "super-tab" },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            menu = {
                border = "rounded",
            },
            ghost_text = {
                enabled = true,
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
        },
        signature = { enabled = true },
        sources = {
            default = { "avante", "emoji", "lsp", "path", "snippets", "buffer" },
            providers = {
                avante = {
                    module = "blink-cmp-avante",
                    name = "Avante",
                    opts = {},
                },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15,
                    opts = {
                        insert = true,
                    },
                    should_show_items = function()
                        return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
                    end,
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
