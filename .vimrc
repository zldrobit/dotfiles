set nocompatible
set backspace=indent,eol,start
set ruler
set showcmd
set wildmenu
set display=truncate
set scrolloff=5
set incsearch
set nomodeline
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set hls

syntax on
filetype plugin indent on

inoremap <C-U> <C-G>u<C-U>

" Trim trailing white spaces
nnoremap <Leader>ts :%s/\s\+$//ge<CR>

" Quickfix buffer list
nnoremap <silent> <Leader>ls :call setqflist(getbufinfo({'buflisted':1})) \| copen<CR>

" Show current git branch (for current working directory)
nnoremap <Leader>br :echom system('bash -ic __git_ps1')<CR>

" Map F3 F4 for :cnext :cprev
if $TERM == "cygwin"
  set <F3>=[[C
  set <F4>=[[D
endif
nnoremap <F3> :cnext<CR>
nnoremap <F4> :cprev<CR>

" Vertical terminal
cnoreabbrev <expr> vterm (getcmdtype() == ':' && getcmdline() =~ '^vterm$')? 'vert term' : 'vterm'

" Vertical split buffer
cnoreabbrev <expr> vsb (getcmdtype() == ':' && getcmdline() =~ '^vsb$')? 'vert sb' : 'vsb'

" Tab as space intent
" function! IndentWithSpaces(spaces)
"   let &l:tabstop=a:spaces
"   let &l:softtabstop=a:spaces
"   let &l:shiftwidth=a:spaces
"   let &l:expandtab=1
" endfunction

command -nargs=1 IndentWithSpaces set ts=<args> sts=<args> sw=<args> expandtab
command -nargs=0 ShowIndent set ts? sts? sw? expandtab?

" set termwinkey=<C-X>
set grepprg=grep\ -n\ --color=always

" Difftool and mergetool keymap
nnoremap <Leader>lo :diffget<Space>LOCAL<CR>
nnoremap <Leader>re :diffget<Space>REMOTE<CR>

" Backspace for last inserted location
nnoremap <backspace> g;

" TODO: open on last edited position
