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
" set nomodeline
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set shiftround
" set pastetoggle=<Leader>pa
set bg=dark
if has('gui_running')
	colorscheme desert  " signcolumn is not highlighted
	let g:lsp_diagnostics_enabled = 1
	let g:lsp_document_highlight_enabled = 1
else
	let g:lsp_diagnostics_enabled = 0
	let g:lsp_document_highlight_enabled = 0
endif
set guifont=Consolas:h11
set guicursor+=a:blinkon0
" set mouse=n

function s:scriptexists(script)
  " if has('unix')
		" let scriptpath = $HOME . '/.vim/**/'
  " elseif has('win32')
		" let scriptpath = $USERPROFILE . '/vimfiles/**/'
  " endif
	let scriptpath = split(&rtp, ',')[0]
	let res = glob(scriptpath . '/**/' . a:script)
  if len(res) > 0
    return 1
  endif
endfunction

" vim-fugitive status line
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
    exe ':tabe ' . (filereadable('.vimrc') ? '.vimrc' : $MYVIMRC)
  else
    exe ':vs ' . (filereadable('.vimrc') ? '.vimrc' : $MYVIMRC)
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

" inline calculation
nnoremap <Leader>ca :s/=.*$//e<CR>:let @/ = ''<CR>^y$i<End> = <C-R>=<C-R>0<CR><C-C>

" Vertical terminal
cnoreabbrev <expr> vterm (getcmdtype() == ':' && getcmdline() =~ '^vterm$')? 'vert term' : 'vterm'

" Vertical split buffer
cnoreabbrev <expr> vsb (getcmdtype() == ':' && getcmdline() =~ '^vsb$')? 'vert sb' : 'vsb'

" Replace
" cnoreabbrev <expr> rep (getcmdtype() == ':' && getcmdline() =~ '^rep$')?
"   \ 's/' . expand('<cword>') . '/<Left>' : 'rep'
" command -nargs=1 Replace exe 'normal! ma:%s/' . expand('<cword>') . '/' . <q-args> . '/g<CR>`a'
" function s:Replace(pat, sub, ...) range
"   exe a:firstline . ',' . a:lastline . 's/' . a:pat. '/' . a:sub . '/g' . (exists("a:1") ? 'c' : '')
" endfunction
" command -nargs=* -range=% Replace <line1>,<line2>call s:Replace(<f-args>)
" nnoremap <Leader>re :Replace <C-R><C-W>
" vnoremap <Leader>re :Replace <C-R><C-W>
nnoremap <Leader>re :%s/<C-R><C-W>//gI<Left><Left><Left>
vnoremap <Leader>re :%s/<C-R><C-W>//gI<Left><Left><Left>
nnoremap <Leader>Re :%s/\<<C-R><C-W>/>\/gI<Left><Left><Left>
vnoremap <Leader>Re :%s/\<<C-R><C-W>/>\/gI<Left><Left><Left>

" List chars
let s:listchars = &listchars
function s:ToggleListChars()
	if &list == 0
		let &listchars = "tab:>-,trail:-"
		set list
	else
		let &listchars = s:listchars
		set nolist
	endif
endfunction
command -nargs=0 ToggleListChars call s:ToggleListChars()
nnoremap <Leader>li :ToggleListChars <CR>


" sudo overwrite
cabbrev w!! w !sudo tee % >/dev/null 2>&1

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

" Prepend numbers in lines
function! s:PrependLineNumbers(...) range
  let counter = a:0 > 0 ? a:1 : 0
  let suffix = a:0 > 1 ? a:2 . " " : " "

  for i in range(a:firstline, a:lastline)
    execute i . "normal! I" . printf("%3d", counter) . suffix
    " execute i . "normal! I" . "001" . suffix
    let counter = counter + 1
  endfor
endfunction

command -nargs=* -range=% PrependLineNumbers <line1>,<line2>call s:PrependLineNumbers(<f-args>)
vnoremap <Leader>nu :PrependLineNumbers<CR>
nnoremap <Leader>nu :PrependLineNumbers<CR>

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

" fold :Gclog by files
au FileType git setlocal foldmethod=syntax

" gitgutter
let g:gitgutter_enabled = 0
nnoremap <Leader>ga :GitGutterToggle<CR>

" FZF
nnoremap <Leader>ff :FZF<CR>

" Python
" autocmd! FileType python setlocal ts=8 sts=4 sw=4 expandtab

" DVC
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock setfiletype yaml

" vim-lsc
" let g:lsc_server_commands = { 'python' : 'pyright-langserver --stdio'}
" let g:lsc_auto_map = v:true
" let s:lsc_tips = v:false
" function! s:ToggleLscTips()
"   if s:lsc_tips == v:true
"     let g:lsc_enable_autocomplete = v:false
"     let g:lsc_enable_diagnostics = v:false
"     let g:lsc_enable_highlights = v:false
"     highlight link lscReference Normal
"     let s:lsc_tips = v:false
"   else
"     let g:lsc_enable_autocomplete = v:true
"     let g:lsc_enable_diagnostics = v:true
"     let g:lsc_enable_highlights = v:true
"     highlight link lscReference Search
"     let s:lsc_tips = v:true
"   endif
" endfunction
" let s:lsc_tips = !s:lsc_tips
" call s:ToggleLscTips()
" nnoremap <silent> <Leader>tt :call <SID>ToggleLscTips()<CR>

" vim-commentary
nmap <C-_> <Plug>CommentaryLine
vmap <C-_> <Plug>Commentary
nmap <C-/> <Plug>CommentaryLine
vmap <C-/> <Plug>Commentary

" vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': 'md'}]
let g:vimwiki_filetypes = ["markdown"]
let g:vimwiki_global_ext = 0

" NERDTree Directory Collapsible/Expandable Indication
"
let g:NERDTreeDirArrowCollapsible="-"
let g:NERDTreeDirArrowExpandable="+"

" Plugins
let s:vim_plug = s:scriptexists('plug.vim')
if s:vim_plug == 1
  call plug#begin()
  Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
	Plug 'airblade/vim-gitgutter'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " Plug 'ctrlpvim/ctrlp.vim'
  " Plug 'mileszs/ack.vim'  " , { 'tag': 'v1.0.9' }
  " Plug 'pechorin/any-jump.vim'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'
  Plug 'vimwiki/vimwiki'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

  Plug 'preservim/nerdtree'
  call plug#end()
endif

" vim-lsp
 
" let g:lsp_log_file = expand('~/vim-lsp.log')
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
		if g:lsp_diagnostics_enabled == 1 | setlocal signcolumn=yes | endif
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_settings = {
\   'pylsp': {
\     'workspace_config': {
\       'pylsp': {
\         'plugins': {
\           'pycodestyle': {
\             'enabled': v:false,
\           },
\           'autopep8': {
\             'enabled': v:false,
\           },
\           'yapf': {
\             'enabled': v:true,
\           },
\           'flake8': {
\             'enabled': v:false,
\           },
\         }
\       }
\     }
\   },
\}

function Tapi_Drop(bufnum, arglist)
	let l:pwd = a:arglist[0]
	let l:filename = a:arglist[1]
	let l:fullpath = l:pwd .. '/' .. l:filename
	execute "drop " .. l:fullpath
endfunction

" Using bash completion for Gclog

" function GclogCompletion(ArgLead, CmdLine, CursorPos)
"     let l:words = split(a:CmdLine)
"     let l:words[0] = 'git log'
"     let l:command = join(l:words)
"     return bash#complete(l:command)
" endfunction

" vim: set sw=2 ts=2 sts=2 expandtab:
