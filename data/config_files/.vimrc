version 7.0

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set modelines=0

set history=50 " keep 50 lines of command line history
set number     " turn on line numbering
set numberwidth=4 " always use 4 columns for numbering + space

" set lines=48  " start windwos full height of my screen
" set columns=84 " increase width by 5 to accomodate line numbers

filetype off
set fileformat=unix
" call pathogen#infect()
syntax on
filetype plugin indent on

set ai
" set expandtab
set shiftwidth=3
set tabstop=3

" http://vim.wikia.com/wiki/Working_with_Unicode
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

" make vim behave in a sane manner
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler      " show the cursor position all the time
set backspace=indent,eol,start "allow backspacing over everything in insert mode
set laststatus=2
" set relativenumber
" set undofile
" set undodir=~/.vimfiles/undo_files/,.

" , is easier to type than \
let mapleader = ","

" tame searching / moving
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set guifont=Envy\ Code\ R:h10,Droid\ Sans\ Mono:h9,Consolas:h9,courier_new:h9,\ 7x13
endif

" handle long lines correctly
set wrap
set textwidth=79
set formatoptions=qrn1
if exists('+colorcolumn')
  set colorcolumn=80
endif

set list
execute 'set listchars=trail:'.nr2char(183).',tab:'.nr2char(187).nr2char(183)
" set listchars=tab:▸\ ,eol:¬



" maximize window on startup
"au GUIEnter * simalt ~x



" Ctrl-P bundle
" http://kien.github.com/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=tmp\*,*.swp,*.zip,*.exe,.~lock.*

" Select colormap: 'soft', 'softlight', 'standard' or 'allblue'
let xterm16_colormap = 'allblue'
" Select brightness: 'low', 'med', 'high', 'default' or custom levels.
let xterm16_brightness = 'med'

color koehler
" color molokai
" customize koehler line numbering colors
hi LineNr   term=underline  cterm=bold  ctermfg=darkcyan  guifg=#999999
hi Folded   cterm=bold ctermbg=black guibg=#222222 guifg=#777788
hi SpecialKey guifg=#2d2d2d
hi ColorColumn guibg=gray18
"color vividchalk

set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P

" Display window width and height in GUI
if has('gui_running') && has('statusline')
  let &statusline=substitute(
                 \&statusline, '%=', '%=%{winwidth(0)}x%{winheight(0)}  ', '')
  set laststatus=2
endif


set undolevels=100
" autosave on focus lost
au FocusLost * :wa
"set lcs=tab:>-,trail:-



" let php_folding=0
" source $VIMRUNTIME/plugin/phpfolding.vim
" au FileType php setlocal EnableFastPHPFolds

" for PHP Folds
map <F5> <Esc>:EnableFastPHPFolds
map <F6> <Esc>:EnablePHPFolds
map <F7> <Esc>:DisablePHPFolds

" disable arrows keys in normal mode; j and k work on screen lines not file
" lines
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" get rid of F1 help key that gets hit with esc key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" make ; do the same thing as : - it's one less key to hit when saving a file
nnoremap ; :

map! <xHome> <Home>
map! <xEnd> <End>


" tab navigation like firefox
nmap <C-S-tab> :tabprevious<cr>
nmap <C-tab> :tabnext<cr>
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
imap <C-S-tab> <ESC>:tabprevious<cr>i
imap <C-tab> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr> 

" new file types
" thtml
au BufRead,BufNewFile *.thtml set filetype=php

" custom leader commands
" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" opem .vimrc in vertically split window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" quicker escaping - assuming I never need to type a jj in insert mode
inoremap jj <ESC>

" open a new vertical split and switch over to it
nnoremap <leader>w <C-w>v<C-w>l
" navigate around splits easier
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" PLUGIN SETTINGS

"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1

" NERD Commenter
