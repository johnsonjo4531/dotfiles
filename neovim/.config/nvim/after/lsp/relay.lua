return {
  cmd = { "npx", "relay-compiler", "lsp" },
  filetypes = { "graphql" },

  root_dir = vim.fs.root(0, {
    "relay.config.json",
    "package.json",
  }),
}
