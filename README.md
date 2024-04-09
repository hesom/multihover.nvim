# multihover.nvim

Neovim plugin that combines multiple LSP hover sources (and optionally diagnostics) in a single hover popup, similar to vscode.

The code is heavily based the discussion in [this issue](https://github.com/lewis6991/hover.nvim/issues/34), but is standalone doesn't require [hover.nvim](https://github.com/lewis6991/hover.nvim).

# Setup
via lazy.nvim (showing defaults):
```lua
{
  'hesom/multihover.nvim',
  config = function()
    require("multihover").setup({
      include_diagnostics = true,
      show_titles = false,
      popup_config = {
        focusable = true,
        focus_id = "textDocument/hover",
      },
    }),
    vim.lsp.buf.hover = require("multihover").hover
  end
}
```
If you don't want to overwrite the default `vim.lsp.buf.hover` function you can just replace that line with a keybind of your choice that calls require("multihover").hover.
