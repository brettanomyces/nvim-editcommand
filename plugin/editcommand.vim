" Plugin: https://github.com/brettanomyces/nvim-editcommand
" Description: Edit command in buffer inside Neovim

if exists('g:loaded_editcommand')
  finish
endif
let g:editcommand_loaded = 0

" Given a string trim from the first character up to and including the
" character after the prompt. The character after the prompt, if it exists, is
" expected to be a space. The character after the space will not exist if we
" are editing an empty command.
function! s:strip_prompt(commandline, prompt)
  let l:prompt_idx = stridx(a:commandline, a:prompt) + len(a:prompt) + 1
  return strpart(a:commandline, l:prompt_idx)
endfunction

" Extract the command from the current buffer and save it to a script local
" variable. The command is expected to be after the last occurecne of the
" prompt and may span multiple lines.
function! s:extract_command() abort
  " default bash prompt is $ so use that as a default
  let l:prompt = get(g:, 'editcommand_prompt', '$')
  " starting at the last line search backwards through the file for a line containing the prompt
  let l:line_number = line('$')
  while l:line_number > 0
    " if a user has not entered a command then there will not be a space after the last prompt
    let l:space_or_eol = '\( \|$\)'
    if match(getline(l:line_number), l:prompt . l:space_or_eol) !=# -1
      " combine all the lines from the line containing the prompt to the last line into a single string
      let l:commandline = join(getline(l:line_number, '$'), "\n")      
      " save command to a script local variable
      let s:command = s:strip_prompt(l:commandline, l:prompt)
      return
    endif
    let l:line_number = l:line_number - 1
  endwhile

  " if we reach this point then the prompt was not found
  echoerr "Could not find prompt '" . l:prompt . "' in buffer"

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

  " save command when leaving buffer
  autocmd BufLeave <buffer> let s:command = join(getline(1, '$'), "\n") | autocmd! BufLeave <buffer>
endfunction

function! s:open_temporary_file()
  execute 'new ' . tempname()

  setlocal bufhidden=delete
  setlocal noswapfile

  " save command when writing buffer
  autocmd BufWritePre <buffer> let s:command = join(getline(1, '$'), "\n")
  autocmd BufLeave <buffer> autocmd! * <buffer>

endfunction

function! s:set_terminal_autocmd()
  " set an autocmd on the current (terminal) buffer that will run when the buffer is next entered
  autocmd BufEnter <buffer>
        \ call s:put_command() |
        \ startinsert |
        \ autocmd! BufEnter <buffer>

endfunction

function! s:edit_command()

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
  " strip leading whitespace
  %left

  " a single line in terminal buffer that wraps is yanked as two lines
  " so we must join to recombine it. However we do not want to join lines
  " that end with a '\'.

  " replace backslash followed by newline with \$ so we can see where to add newlines after join
  silent! %substitute/\\$/\\\$

  %join!

  silent! %substitute/\\\$/\\\r/g

endfunction

" extract the command, clear the commandline, set up terminal autocmd then edit the command.
tnoremap <silent> <Plug>EditCommand <c-\><c-n>:call <SID>extract_command()<cr>999@r:call <SID>set_terminal_autocmd()<cr>:call <SID>edit_command()<cr>

if !exists("g:editcommand_no_mappings") || ! g:editcommand_no_mappings
  tmap <c-x><c-e> <c-c><Plug>EditCommand
endif
