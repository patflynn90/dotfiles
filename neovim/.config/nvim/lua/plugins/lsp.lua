return {
    "neovim/nvim-lspconfig",

    dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
    },

    config = function()
        --------------------------------------------------------------------------
        -- Shim deprecated vim.lsp.buf_get_clients() --------------------------
        --------------------------------------------------------------------------
        -- If any plugin still calls the old function we silently forward it to
        -- the new API, preventing the deprecation warning.
        vim.lsp.buf_get_clients = function(bufnr)
            return vim.lsp.get_clients({ bufnr = bufnr })
        end
        --------------------------------------------------------------------------

        --------------------------------------------------------------------------
        -- Key-maps & buffer-local helpers
        --------------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("ptf-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, fn, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("<leader>cn", vim.lsp.buf.rename, "Rename term")
                map("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "x" })
                map("<leader>cr", require("fzf-lua").lsp_references, "References")
                map("<leader>ci", require("fzf-lua").lsp_implementations, "Implementation")
                map("<leader>cd", require("fzf-lua").lsp_definitions, "Definition")
                map("<leader>cD", vim.lsp.buf.declaration, "Declaration")
                map("<leader>cO", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")
                map("<leader>cW", require("fzf-lua").lsp_live_workspace_symbols, "Open Workspace Symbols")
                map("<leader>ct", require("fzf-lua").lsp_typedefs, "Type Definition")

                -- Compat helper for 0.10 vs 0.11
                local function supports(client, method, bufnr)
                    if vim.fn.has("nvim-0.11") == 1 then
                        return client:supports_method(method, bufnr)
                    end
                    return client.supports_method(method, { bufnr = bufnr })
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)

                ----------------------------------------------------------------------
                -- Highlight occurrences under cursor
                ----------------------------------------------------------------------
                if client and supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local hl_grp = vim.api.nvim_create_augroup("ptf-lsp-highlight", { clear = false })

                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = hl_grp,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = hl_grp,
                        callback = vim.lsp.buf.clear_references,
                    })
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("ptf-lsp-detach", { clear = true }),
                        callback = function(ev)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = hl_grp, buffer = ev.buf })
                        end,
                    })
                end

                ----------------------------------------------------------------------
                -- Toggle inlay hints
                ----------------------------------------------------------------------
                if client and supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        --------------------------------------------------------------------------
        -- Diagnostics
        --------------------------------------------------------------------------
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            } or {},
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(d)
                    return d.message
                end,
            },
        })

        --------------------------------------------------------------------------
        -- LSP server definitions
        --------------------------------------------------------------------------
        local original_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)
        local util = require("lspconfig.util")

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            },
            clangd = {},
            bashls = {},
            marksman = {},
            pylsp = {},
            zls = {},
            v_analyzer = {},
            perlnavigator = {},
            -- add more servers here …
        }

        --------------------------------------------------------------------------
        -- Mason install helpers
        --------------------------------------------------------------------------
        local ensure = vim.tbl_keys(servers)
        vim.list_extend(ensure, {
            "stylua", -- Lua formatter
            "isort", -- Python imports sorter
            "black", -- Python formatter
            "swiftlint", -- Swift linter
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure })

        --------------------------------------------------------------------------
        -- LSPConfig setup via Mason
        --------------------------------------------------------------------------
        require("mason-lspconfig").setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                function(name)
                    local opts = servers[name] or {}
                    opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
                    require("lspconfig")[name].setup(opts)
                end,
            },
        })

        require("lspconfig").sourcekit.setup({
            cmd = { "sourcekit-lsp" },
            filetypes = { "swift", "objective-c", "objective-cpp" },
            root_dir = util.root_pattern("Package.swift", ".git"),
            capabilities = capabilities,
        })
    end,
}
