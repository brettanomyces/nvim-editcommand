" Plugin: https://github.com/brettanomyces/nvim-editcommand
" Description: Edit command in buffer inside Neovim

if exists('g:loaded_editcommand')
  finish
endif
let g:editcommand_loaded = 1

" setup default variables if user has not defined any
let g:editcommand_prompt = get(g:, 'editcommand_prompt', '$')
let g:editcommand_mapping = get(g:, 'editcommand_mapping', '<c-x><c-e>')

execute printf('tnoremap %s <c-\><c-n>:call SaveRegister()<cr>:call YankCommand()<cr>A<c-c><c-\><c-n>:call EditCommand()<cr>', g:editcommand_mapping)

function! SaveRegister()
  let s:register = @c
endfunction

function! RestoreRegister()
  let @c = s:register
endfunction

function! YankCommand()
  " if a user has not entered a command then there will not be a space after the last prompt
  let l:space_or_eol = '\( \|$\)'
  silent execute ':?' . g:editcommand_prompt . l:space_or_eol . '?,$y c'
endfunction

function! PutCommand()
  silent put! c
endfunction

function! EditCommand()
  " - set an autocmd on the current (terminal) buffer that will run when the buffer is next entered
  " - put from register c (where the new command will be)
  " - remove the autocmd
  " - go to insert mode
  autocmd BufEnter <buffer>
        \ call PutCommand() |
        \ call RestoreRegister() |
        \ autocmd! BufEnter <buffer> |
        \ startinsert

  " command starts after the prompt +1 for a possible space
  let l:commandstart =
        \ stridx(@c, get(g:, 'editcommand_prompt'))
        \ + len(get(g:, 'editcommand_prompt'))
        \ + 1
  let @c = strpart(@c, l:commandstart)

  " open new empty buffer
  new

  " make buffer a scratch buffer
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile

  " put command into buffer
  silent put! c

  " a single line in terminal buffer that wraps is yanked as two lines
  " so we must join to recombine it. However we do not want to join lines
  " that end with a '\'. Also removes all the trailing empty lines.
  vglobal/\\$/join!
  %left

  " copy buffer to register when it is closed
  autocmd BufLeave <buffer> :silent %yank c

endfunction
