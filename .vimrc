set nocompatible
set backspace=indent,eol,start
set ruler
set showcmd
set wildmode=longest:full,full
set wildmenu
set display=truncate
set scrolloff=5
set hlsearch
set incsearch
set nomodeline
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set shiftround
" set pastetoggle=<Leader>pa
if has('gui_running')
  set bg=light
else
  set bg=dark
endif
" set mouse=n

" vim-fugitive status line
function s:scriptexists(script)
  if has('unix')
    silent let scriptlist = systemlist('find ~/.vim -name '. a:script)
  elseif has('win32')
    silent let scriptlist = systemlist('"cd %userprofile%\vimfiles && dir /s '. a:script . ' 2>&1 | findstr ' . a:script . '"')
  endif
  if len(scriptlist) > 0
    return 1
  endif
endfunction
let s:fugitive = s:scriptexists('vim-fugitive')
set statusline=%<%f\ %h%m%r
if s:fugitive == 1
  set statusline+=%{FugitiveStatusline()}
endif
set statusline+=%=%#Todo#%.{&paste==1?'[PASTE]':''}%*
set statusline+=\ \ %-14.(%l,%c%V%)\ %P
set laststatus=2

syntax on
filetype plugin indent on

nnoremap <silent> <Leader>pa :set paste!<CR>

inoremap <C-H> <C-G>u<C-H>
inoremap <C-U> <C-G>u<C-U>

" Trim trailing white spaces
nnoremap <silent> <Leader>ts ma:let tmp=@/<CR>:%s/\s\+$//ge<CR>`a:let @/=tmp<CR>

" Delete continuous spaces
" nnoremap ds lgEldW

" Quickfix buffer list
nnoremap <silent> <Leader>ls :call setqflist(getbufinfo({'buflisted':1})) \| copen<CR>

" Show current git branch (for current working directory)
nnoremap <Leader>br :echo system('bash -ic __git_ps1')<CR>

" C-L to clear search
nnoremap <C-L> :nohlsearch<CR><C-L>

" Map F3 F4 for :cnext :cprev
if $TERM ==? "cygwin"
  set <F3>=[[C
  set <F4>=[[D
endif
nnoremap <F3> :cnext<CR>
nnoremap <F4> :cprev<CR>

" Edit vimrc
function s:Vimrc(tab)
  if a:tab
    exe ':tabe' . (filereadable('.vimrc') ? '.vimrc' : $MYVIMRC)
  else
    exe ':vs' . (filereadable('.vimrc') ? '.vimrc' : $MYVIMRC)
  endif
endfunction
command -nargs=1 Vimrc call s:Vimrc(<args>)
nnoremap <Leader>rc :Vimrc v:false<CR>
nnoremap <Leader>Rc :Vimrc v:true<CR>

" Switch cursor status
nnoremap <Leader>cu :set cursorline! cursorcolumn!<CR>

" Switch between h/hpp and c/cpp files
nnoremap <silent> <Leader>ch :silent exe "e " . substitute(expand('%'), '\.\([ch]\)\(pp\)$',
    \ '\= "." . (submatch(1) == "c" ? "h" : "c") . submatch(2)', "")<CR>`"

" Change dir to current file
nnoremap <silent> <Leader>cd :chdir %:p:h<CR>

" New tab for the current window
nnoremap <silent> <C-W>t :tab split<CR>
tnoremap <silent> <C-W>t <C-W>:tab split<CR>

" Readline style insert
inoremap <C-A>  <C-O>^
inoremap <C-E>  <C-O>$
inoremap <C-B>  <C-O>B
inoremap <C-F>  <C-O>W
if &shell =~ 'bash'
  execute "set <M-\\>=\e\\"
endif
nnoremap <M-\>  lgEldW
inoremap <M-\>  <C-C>llgEldWi

" Readline style in command mode
cnoremap <C-A> <Home>
" cnoremap <C-K> <Home>

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
  \ '(empty(submatch(2)) ? "" : ":PORT")/g<CR>'

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

" Search in current buffers
function! s:Search(pat)
  echo a:pat
  let l:bufnr = bufnr('%')
  exe 'cex [] | silent! vimgrepadd /' . a:pat . '/j %'
  exe 'buffer ' . l:bufnr
  cw
  let @/ = a:pat
endfunction
command -nargs=1 Search call s:Search(<q-args>)
nnoremap <silent> <Leader>ss :Search <C-R><C-W><CR>
vnoremap <silent> <Leader>ss "zy:<C-U>Search <C-R>z<CR>

" Search in buffers
function s:BufSearch(pat)
  let l:bufnr = bufnr('%')
  exe 'cex [] | silent! bufdo vimgrepadd /' . a:pat . '/j %'
  exe 'buffer ' . l:bufnr
  cw
endfunction
command -nargs=1 BufSearch call s:BufSearch(<q-args>)
nnoremap <silent> <Leader>bs :BufSearch <C-R><C-W><CR>
vnoremap <silent> <Leader>bs :<C-U>BufSearch <C-R><C-W><CR>

" Search in git ls-files
function s:GitSearch(pat)
  " Prepend noautocmd for fast grep
  exe 'cex[] | vimgrep /' . a:pat . '/j `git ls-files` | cw'
endfunction
command -nargs=1 GitSearch call s:GitSearch(<q-args>)
nnoremap <Leader>gs :GitSearch <C-R><C-W><CR>
vnoremap <Leader>gs :<C-U>GitSearch <C-R><C-W><CR>

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

" Insert numbers in the begin of lines
function! s:InsertLineNumbers(...) range
  let counter = a:0 > 0 ? a:1 : 0
  let suffix = a:0 > 1 ? a:2 . " " : " "

  for i in range(a:firstline, a:lastline)
    execute i . "normal! I" . printf("%3d", counter) . suffix
    " execute i . "normal! I" . "001" . suffix
    let counter = counter + 1
  endfor
endfunction

command -nargs=* -range=% InsertLineNumbers <line1>,<line2>call s:InsertLineNumbers(<f-args>)
vnoremap <Leader>in :InsertLineNumbers<CR>

" Insert in terminal buffer the filename of the last visited window
tnoremap <silent> <C-W>f <C-W>:call term_sendkeys(bufnr(), fnamemodify(bufname(winbufnr(winnr('#'))), ':p'))<CR>

" Preview for quickfix
augroup PreviewQuickfix
  au!
  au FileType qf nnoremap <buffer> m <CR><C-W>p
  " TODO: May be polluted in using Git
  " au FileType fugitive nnoremap <buffer> m <CR><C-W>p
augroup END

" Toggle vim-fugitive's Git status window
function! s:ToggleGstatus() abort
  for l:winnr in range(1, winnr('$'))
    if !empty(getwinvar(l:winnr, 'fugitive_status'))
      execute l:winnr.'close'
      return
    endif
  endfor
  Git
endfunction

nnoremap <silent> <Leader>gg :call <SID>ToggleGstatus()<CR>

" Show only vim-fugitive
function! s:GitOnly() abort
  Git
  wincmd o
endfunction

nnoremap <silent> <Leader>GG :call <SID>GitOnly()<CR>

augroup my-fugitive
  au!
  au FileType fugitive nmap <silent> dV dv:call <SID>ToggleGstatus()<CR>
  au FileType fugitive nnoremap <silent> m< :silent make pre-git<CR><C-L>
  au FileType fugitive nnoremap <silent> m> :silent make post-git<CR><C-L>
augroup END

" Python
autocmd! FileType python setlocal ts=8 sts=4 sw=4 expandtab

" DVC
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock setfiletype yaml

" vim-lsc
let g:lsc_server_commands = { 'python' : 'pyright-langserver --stdio'}
let g:lsc_auto_map = v:true
let s:lsc_tips = v:false
function! s:ToggleLscTips()
  if s:lsc_tips == v:true
    let g:lsc_enable_autocomplete = v:false
    let g:lsc_enable_diagnostics = v:false
    let g:lsc_enable_highlights = v:false
    highlight link lscReference Normal
    let s:lsc_tips = v:false
  else
    let g:lsc_enable_autocomplete = v:true
    let g:lsc_enable_diagnostics = v:true
    let g:lsc_enable_highlights = v:true
    highlight link lscReference Search
    let s:lsc_tips = v:true
  endif
endfunction
let s:lsc_tips = !s:lsc_tips
call s:ToggleLscTips()
nnoremap <silent> <Leader>tt :call <SID>ToggleLscTips()<CR>

" vim-commentary
nmap <C-_> <Plug>CommentaryLine
vmap <C-_> <Plug>Commentary

" Plugins
let s:vim_plug = s:scriptexists('plug.vim')
if s:vim_plug == 1
  call plug#begin()
  Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'mileszs/ack.vim'  " , { 'tag': 'v1.0.9' }
  Plug 'pechorin/any-jump.vim'
  Plug 'natebosch/vim-lsc'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  call plug#end()
endif

" Using bash completion for Gclog

" function GclogCompletion(ArgLead, CmdLine, CursorPos)
"     let l:words = split(a:CmdLine)
"     let l:words[0] = 'git log'
"     let l:command = join(l:words)
"     return bash#complete(l:command)
" endfunction

