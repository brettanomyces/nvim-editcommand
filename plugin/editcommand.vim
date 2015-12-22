" Plugin: https://github.com/brettanomyces/nvim-editcommand
" Description: Edit command in buffer inside Neovim

if exists('g:loaded_editcommand')
  finish
endif
let g:editcommand_loaded = 1

" default bash prompt is $ so use that as a default
let g:editcommand_prompt = get(g:, 'editcommand_prompt', '$')

function! s:yank_command()
  " save current contents of register
  let l:register = @c

  " if a user has not entered a command then there will not be a space after the last prompt
  let l:space_or_eol = '\( \|$\)'

  " if the last line contains a prompt then yank the last line, else yank from 
  " the last line contianing a prompt till the last line
  let l:last = getline('$')
  if match(l:last, g:editcommand_prompt . l:space_or_eol) !=# -1
    silent execute '$y c'
  else
    silent execute ':?' . g:editcommand_prompt . l:space_or_eol . '?,$y c'
  endif

  " command starts after the prompt +1 for a possible space
  let l:commandstart =
        \ stridx(@c, get(g:, 'editcommand_prompt'))
        \ + len(get(g:, 'editcommand_prompt'))
        \ + 1

  let s:command = strpart(@c, l:commandstart)

  " restore original contents of register
  let @c = l:register
endfunction

function! s:put_command()
  silent put! =s:command
endfunction

function! s:open_scratch_buffer()
  " open new empty buffer
  new

  " make buffer a scratch buffer
  setlocal buftype=nofile
  setlocal bufhidden=unload
  setlocal noswapfile

  " copy buffer to register when it is closed
  autocmd BufLeave <buffer> let s:command = join(getline(1, '$'), '\n') | autocmd! BufLeave <buffer>
endfunction

function! s:open_temporary_file()
  execute 'new ' . tempname()

  setlocal bufhidden=delete
  setlocal noswapfile

  " copy buffer to register when it is saved
  autocmd BufWritePre <buffer> let s:command = join(getline(1, '$'), '\n')
  autocmd BufLeave <buffer> autocmd! * <buffer>

endfunction

function! s:edit_command()
  " - set an autocmd on the current (terminal) buffer that will run when the buffer is next entered
  autocmd BufEnter <buffer>
        \ call s:put_command() |
        \ startinsert |
        \ autocmd! BufEnter <buffer>

  if !exists("g:editcommand_use_temp_file") || ! g:editcommand_use_temp_file
    call s:open_scratch_buffer()
  else
    call s:open_temporary_file()
  endif

  " put command into buffer
  silent put! =s:command
  " clear command
  let s:command = ''

  call s:format_command()

endfunction

function! s:format_command()
  " push all text to the left
  %left

  " a single line in terminal buffer that wraps is yanked as two lines
  " so we must join to recombine it. However we do not want to join lines
  " that end with a '\'.

  " replace backslash followed by newline with \$ so we can see where to add newlines after join
  silent! %substitute/\\$/\\\$

  %join!

  silent! %substitute/\\\$/\\\r/g

endfunction

tnoremap <silent> <Plug>EditCommand <c-\><c-n>:call <SID>yank_command()<cr>A<c-c><c-\><c-n>:call <SID>edit_command()<cr>

if !exists("g:editcommand_no_mappings") || ! g:editcommand_no_mappings
  tmap <c-x><c-e> <Plug>EditCommand
endif
