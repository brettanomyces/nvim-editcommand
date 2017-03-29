# nvim-editcommand

Edit your current shell command inside a scratch buffer.

nvim-editcommand provides similar functionality to `fc` or `<c-x><c-e>`/`Ctrl-x,Ctrl-e`, allowing the user to edit their current shell command in an editor. 

The reason a user may want to do this is that it allows them to access the editors functionality that may not be available on the command line.

It also allows the user to edit command in shell's that may not otherwise provide the same functionality, e.g. `python`/`ruby` interpreters.

nvim-editcommand would be useful for a Neovim user who is running their shell inside a Neovim terminal buffer. In such a situation `<c-x><c-e>` is still available but (assuming your `$EDITOR` is `nvim`) it will have to open a new Neovim instance inside the terminal inside the existing Neovim instance, which can quickly become rather cumbersome to navigate in and out of.

## Installation

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
call plug#begin('~/.nvim/plugged')
Plug 'brettanomyces/nvim-editcommand'
...
call plug#end()
```

## Configuration

User should set `g:editcommand_prompt` to their shell prompt

```vim
let g:editcommand_prompt = '>'       " default is '$'
```

The default mapping is `<c-x><c-e>` however you may disable this mapping by setting

```vim
let g:editcommand_no_mappings = 1    " default is 0
```

To provide you own mapping provide a terminal mapping to `<Plug>EditCommand`

```vim
tmap <c-x> <Plug>EditCommand         " default is <c-x><c-e>
```

To use a temporary file rather than a scratch buffer set `g:editcommand_use_temp_file`

```vim
let g:editcommand_use_temp_file = 1  " default is 0
```

## Notes

The scratch buffer cannot be saved, use `:close` or `:bdelete` or `:quit`. 

If using a temporary file the command will only be copied back if you save first `:wquit`.

The command in the buffer will be saved to a script local variable by an autocmd which then removes itself. When the terminal buffer is re-entered the command is copied to the commandline by another autocmd which also removes itself.

## Feedback

Suggestions / Issues / Pullrequest are all very much welcome.
