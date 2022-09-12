set nocompatible
set backspace=indent,eol,start
set ruler
set showcmd
set wildmode=longest:full,full
set wildmenu
set display=truncate
set scrolloff=5
set incsearch
set nomodeline
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set hls
set bg=dark
" set mouse=n

syntax on
filetype plugin indent on

inoremap <C-U> <C-G>u<C-U>

" Trim trailing white spaces
nnoremap <silent> <Leader>ts :let tmp=@/<CR>:%s/\s\+$//ge<CR>:let @/=tmp<CR>

" Delete continuous spaces
nnoremap ds gEldW

" Quickfix buffer list
nnoremap <silent> <Leader>ls :call setqflist(getbufinfo({'buflisted':1})) \| copen<CR>

" Show current git branch (for current working directory)
nnoremap <Leader>br :echo system('bash -ic __git_ps1')<CR>

" C-L to clear search
nnoremap <C-L> :let @/=''<CR><C-L>

" Map F3 F4 for :cnext :cprev
if $TERM == "cygwin"
  set <F3>=[[C
  set <F4>=[[D
endif
nnoremap <F3> :cnext<CR>
nnoremap <F4> :cprev<CR>

" Edit vimrc
nnoremap <Leader>rc :vs ~/.vimrc<CR>

" Switch cursor status
nnoremap <Leader>cu :set cursorline! cursorcolumn!<CR>

" Vertical terminal
cnoreabbrev <expr> vterm (getcmdtype() == ':' && getcmdline() =~ '^vterm$')? 'vert term' : 'vterm'

" Vertical split buffer
cnoreabbrev <expr> vsb (getcmdtype() == ':' && getcmdline() =~ '^vsb$')? 'vert sb' : 'vsb'

" Replace 
" cnoreabbrev <expr> rep (getcmdtype() == ':' && getcmdline() =~ '^rep$')? 
"   \ 's/' . expand('<cword>') . '/<Left>' : 'rep'
" command -nargs=1 Replace exe 'normal! ma:%s/' . expand('<cword>') . '/' . <q-args> . '/g<CR>`a'
function s:Replace(pat, sub, ...) range
  exe a:firstline . ',' . a:lastline . 's/' . a:pat. '/' . a:sub . '/g' . (exists("a:1") ? 'c' : '')
endfunction
command -nargs=* -range=% Replace <line1>,<line2>call s:Replace(<f-args>)
nnoremap <Leader>re :Replace <C-R><C-W> 
vnoremap <Leader>re :Replace <C-R><C-W> 

" Anonymous IP
command -nargs=0 AnonyIP exe "normal!" .
  \ ':%s/\(\%([0-9]\{1,3}\.\)\{3}[0-9]\{1,3}\)\(:[0-9]\+\)\=/\="IP" .' .
  \ '(empty(submatch(2)) ? "" : ":PORT")/g<CR>"'

" Indentation
function s:Indent(...)
  if a:0 == 0
    set ts? sts? sw? expandtab?
  else
    let l:nspace = a:1
    let &ts=l:nspace
    let &sts=l:nspace
    let &sw=l:nspace
    set expandtab
  endif
endfunction
command -nargs=? IndentWithSpaces call s:Indent(<args>)

" Search in buffers
function s:BufSearch(pat)
  cex [] | silent! bufdo vimgrepadd /a:pat/ % | copen
endfunction
command -nargs=1 BufSearch call s:BufSearch(<args>)
nnoremap <Leader>bs :BufSearch <C-R><C-W>
vnoremap <Leader>bs :BufSearch <C-R><C-W>

" Remove all but the current buffer
function s:OnlyBuffer()
  %bd | e#
endfunction
command -nargs=0 OnlyBuffer call s:OnlyBuffer()
nnoremap <Leader>on :OnlyBuffer<CR>

" set termwinkey=<C-X>
set grepprg=grep\ -n\ --color=always

" Difftool and mergetool keymap
" nnoremap <Leader>lo :diffget<Space>LOCAL<CR>
" nnoremap <Leader>re :diffget<Space>REMOTE<CR>

" (Shift) Backspace for last inserted location
nnoremap <backspace> g;
nnoremap [8;2~ g,

" TODO: open on last edited position

" vim-fugitive status line
function s:scriptexists(script)
  silent let scriptlist = systemlist('find ~/.vim -name '. a:script)
  if len(scriptlist) > 0
    return 1
  endif
endfunction
if s:scriptexists('vim-fugitive')
  set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P
  set laststatus=2
endif

" Preview for quickfix
augroup PreviewQuickfix
  au!
  au FileType qf nnoremap <buffer> m <CR><C-W>p
  " TODO: May be polluted in using Git
  " au FileType fugitive nnoremap <buffer> m <CR><C-W>p
augroup END

" Using bash completion for Gclog

" function GclogCompletion(ArgLead, CmdLine, CursorPos)
"     let l:words = split(a:CmdLine)
"     let l:words[0] = 'git log'
"     let l:command = join(l:words)
"     return bash#complete(l:command)
" endfunction
