--[[
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "auto",
        background = {
            light = "latte",
            dark = "mocha",
        },
        styles = {
            conditionals = { "italic" },
        },
        highlight_overrides = {
            latte = function(latte)
                return {
                    ["@comment"] = { fg = latte.surface1, style = { "italic" } },
                }
            end,
        },
        custom_highlights = function(colors)
            return {
                ["@markup.list.checked.markdown"] = { fg = colors.sapphire },
                Keyword = { style = { "italic" } },
                ["@keyword.function"] = { style = { "italic" } },
                ["@keyword.return"] = { style = { "italic" } },
            }
        end,
        integrations = {
            treesitter = true,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
            which_key = true,
            fzf = true,
            blink_cmp = true,
            mason = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                    ok = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            notify = true,
            render_markdown = true,
        },
        transparent_background = true,
        kitty = true,
    },
}
]]
return {
	"rose-pine/neovim",
	name = "rose-pine",
	opts = {
		variant = "dawn",
	},
	config = function()
		vim.cmd("colorscheme rose-pine")
	end,
}
