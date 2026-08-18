return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        relay_lsp = {
          cmd = { "npx", "relay-compiler", "lsp" },
          filetypes = { "graphql" },
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, {
              "relay.config.json",
              "package.json",
            })

            if root then
              on_dir(root)
            end
          end,
        },
      },
    },
  },
}
