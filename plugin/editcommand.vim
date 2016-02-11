" Plugin: https://github.com/brettanomyces/nvim-editcommand
" Description: Edit command in buffer inside Neovim

if exists('g:loaded_editcommand')
  finish
endif
let g:editcommand_loaded = 1

" default bash prompt is $ so use that as a default
let g:editcommand_prompt = get(g:, 'editcommand_prompt', '$')
let s:space_or_eol = '\( \|$\|\n\)'

function! s:strip_prompt(commandline)
  " strip up to and including the first occurence of the prompt
  let l:prompt_idx = match(a:commandline, g:editcommand_prompt . s:space_or_eol . '\zs')
  return strpart(a:commandline, l:prompt_idx)
endfunction

function! s:extract_command() abort
  " starting at the last line search backwards through the file for a line containing the prompt
  let l:line_number = line('$')
  while l:line_number > 0
    if match(getline(l:line_number), g:editcommand_prompt . s:space_or_eol) !=# -1
      let l:commandline = join(getline(l:line_number, '$'), "\n")
      let l:command = s:strip_prompt(l:commandline)
      " store command in script local variable
      let s:command = s:format_command(l:command)
      return
    endif
    let l:line_number = l:line_number - 1
  endwhile

  " if we reach this point then the prompt was not found
  echoerr "Could not find prompt '" . g:editcommand_prompt . "' in buffer"

endfunction

" remove extra whitespace and newlines caused by our method of extracting text
" from the terminal buffer
function! s:format_command(command)
  " remove all whitespace following a newline
  let l:command = substitute(a:command, '\(\n\)\s*', '\n', "g")
  " remove newlines that do not come after a backslash
  let l:command = substitute(l:command, '\([^\\]\)\n*', '\1', "g")
  return l:command
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
  silent put =s:command
  " remove the (empty) first line
  0,1delete
  " clear scirpt local variable
  let s:command = ''
endfunction

tnoremap <silent> <Plug>EditCommand <c-\><c-n>:call <SID>extract_command()<cr>A<c-c><c-\><c-n>:call <SID>set_terminal_autocmd()<cr>:call <SID>edit_command()<cr>

if !exists("g:editcommand_no_mappings") || ! g:editcommand_no_mappings
  tmap <c-x><c-e> <Plug>EditCommand
endif
