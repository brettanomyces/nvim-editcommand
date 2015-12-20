" Plugin: https://github.com/brettanomyces/nvim-editcommand
" Description: Edit command in buffer inside Neovim

if exists('g:loaded_editcommand')
  finish
endif

let g:editcommand_loaded = 1
let g:editcommand_prompt = '>'
" if a user has not entered a command then there will not be a space after the last prompt
let s:space_or_eol = '\( \|$\)' 

" - yank last line with prompt ('> ') into register c
" - clear commandline
" - call function
tnoremap <c-x> <c-\><c-n>:call CopyCommand()<cr>A<c-c><c-\><c-n>:call EditCommandline()<cr>

function! CopyCommand()
  execute ':?' . g:editcommand_prompt . s:space_or_eol . '?,$y c'
endfunction

function! EditCommandline()
  " - set an autocmd on the current (terminal) buffer that will run when the buffer is next entered
  " - put from register c (where the new command will be)
  " - remove the autocmd
  " - go to insert mode
  autocmd BufEnter <buffer> put c | autocmd! BufEnter <buffer> | call feedkeys('A')

  " command starts after the prompt +1 for a possible space
  let s:commandstart =
        \ strridx(@c, get(g:, 'editcommand_prompt'))
        \ + len(get(g:, 'editcommand_prompt'))
        \ + 1
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
