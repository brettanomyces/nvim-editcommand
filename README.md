# nvim-editcommand

When running bash inside a terminal one can edit the current command in `$EDITOR` using the shortcut `<c-x><c-e>` (`Ctrl-x``Ctrl-e`). However if your `$EDITOR` is Neovim and you are running bash inside a terminal buffer inside Neovim then this trick does not work.

This plugin remaps `<c-x><c-e>` to a function which allows one to edit the current command inside a scratch buffer inside the current Neovim instance. When the scratch buffer is exited and the terminal buffer re-entered, the contents of the scratch buffer are placed on the commandline.

## TODO

- How to install
- gifs?
- contributing
- vi.stackexchange
