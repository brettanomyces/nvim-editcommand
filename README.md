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

User should set `g:editcommand_prompt` to their shell prompt

    let g:editcommand_prompt = '>'       " default is '$'

The default mapping is `<c-x><c-e>` however you may disable this mapping by setting

    let g:edticommand_no_mappings = 1

To provide you own mapping provide a terminal mapping to `<Plug>EditCommand`

    tmap <c-x> <Plug>EditCommand

## Notes

It is expected that after editing the command in the scratch buffer the user closes that buffer using `:bdelete`.

## Feedback

Suggestions / Issues / Pullrequest are all very much welcome.
