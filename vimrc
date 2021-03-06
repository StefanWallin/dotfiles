if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible " Use Vim defaults (much better!)
set bs=indent,eol,start	" allow backspacing over everything in insert mode
set ai " always set autoindenting on
"set backup " keep a backup file
set viminfo='20,\"50 " read/write a .viminfo file, don't store more
                     " than 50 lines of registers
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set et " expand tabs to spaces 
set tabstop=2 softtabstop=0 shiftwidth=2

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Highlight colors
highlight Search ctermbg=yellow ctermfg=black
highlight MarkError ctermbg=red

" Highlight suspicious stuff
match MarkError /[\x7f-\xff]/   " Broken chars
match MarkError /\s\+\%#\@<!$/  " Extra whitespace
match MarkError /\%100v.\+/     " 99 char limit 

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif


execute pathogen#infect()
filetype plugin indent on

" Custom commands
:command! W w
:command! Wq wq
:command! WQ wq
:map <silent> <c-q> :CommandT<CR>
:imap <silent> <c-q> <Esc>:CommandT<CR>
cmap w!! %!sudo tee > /dev/null %


