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

syntax on
filetype plugin indent on

inoremap <C-U> <C-G>u<C-U>

" Trim trailing white spaces
nnoremap <Leader>ts :%s/\s\+$//ge<CR>

" Quickfix buffer list
nnoremap <silent> <Leader>ls :call setqflist(getbufinfo({'buflisted':1})) \| copen<CR>

" TODO: open on last edited position
