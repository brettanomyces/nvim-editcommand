# nvim-editcommand

Edit your current shell command inside a scratch buffer.

nvim-editcommand provides similar functionality to `fc` or `<c-x><c-e>`/`Ctrl-x,Ctrl-e`, allowing the user to edit their current shell command in an editor. The reason a user may want to do this is that it allows them to access the editors functionality that may not be available on the command line.

nvim-editcommand would be useful for a Neovim user who is running their shell inside a Neovim terminal buffer. In such a situation `<c-x><c-e>` is still available but (assuming your `$EDITOR` is `nvim`) it will have to open a new Neovim instance inside the terminal inside the existing Neovim instance, which can quickly become rather cumbersome to navigate in and out of.

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

    let g:edticommand_no_mappings = 1    " default is 0

To provide you own mapping provide a terminal mapping to `<Plug>EditCommand`

    tmap <c-x> <Plug>EditCommand         " default is <c-x><c-e>

## Notes

The scratch buffer cannot be saved. When the scratch buffer is closed, via `:close` or `:bdelete`, the command in the buffer will be copied to a register. When the terminal buffer is re-entered the command is copied from the register to the commandline and the original contents of the reigster are restored. The autocmd that does this is removed after it executes.

## Feedback

Suggestions / Issues / Pullrequest are all very much welcome.
