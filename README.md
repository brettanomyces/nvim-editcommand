# nvim-editcommand

When running bash inside a terminal one can edit the current command in `$EDITOR` using the shortcut `<c-x><c-e>` (`Ctrl-x``Ctrl-e`). However if your `$EDITOR` is Neovim and you are running bash inside a terminal buffer inside Neovim then this trick does not work.

This plugin remaps `<c-x><c-e>` to a function which allows one to edit the current command inside a scratch buffer inside the current Neovim instance. When the scratch buffer is exited and the terminal buffer re-entered, the contents of the scratch buffer are placed on the commandline.

##Installation

### [vim-plug](https://github.com/junegunn/vim-plug)

    call plug#begin('~/.nvim/plugged')
    Plug 'brettanomyces/nvim-editcommand'
    ...
    call plug#end()

## Configuration

User should set `g:editcommand_prompt` to their shell prompt and `g:editcommand_mapping` to their preferred keys.

    let g:editcommand_prompt = '>'       " default is '$'
    let g:editcommand_mapping = '<c-x>'  " default is '<c-x><c-e>'

## Notes

It is expected that after editing the command in the scratch buffer the user closes that buffer using `:bdelete`.

## Feedback

Suggestions / Issues / Pullrequest are all very much welcome.
