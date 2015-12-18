" Plugin: https://github.com/brettanomyces/nvim-editcommand
" Description: Edit command in buffer inside Neovim

if exists('g:loaded_editcommand')
  finish
endif

let g:editcommand_loaded = 1
let g:editcommand_prompt = '> '

" - yank last line with prompt ('> ') into register c
" - clear commandline
" - call function
tnoremap <c-x> <c-\><c-n>:execute ':?> ?,$y c'<cr>A<c-c><c-\><c-n>:call EditCommandline()<cr>

function! EditCommandline()
  " clear search highlighting
  let @/ = ""

  " - set an autocmd on the current (terminal) buffer that will run when the buffer is next entered
  " - put from register c (where the new command will be)
  " - remove the autocmd
  " - go to insert mode
  autocmd BufEnter <buffer> put c | autocmd! BufEnter <buffer> | call feedkeys('A')

  " get all text after prompt '> '
  let s:commandstart = strridx(@c, get(g:, 'editcommand_prompt')) + len(get(g:, 'editcommand_prompt'))
  let s:command = strpart(@c, s:commandstart)

  " open new empty buffer
  new 

  " make buffer a scratch buffer
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile

  " put command into buffer
  put! =s:command

  " remove extra lines
  %join!

  " copy buffer to register when it is closed
  autocmd BufLeave <buffer> :%yank c

endfunction
