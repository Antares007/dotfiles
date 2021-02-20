call plug#begin('~/.config/nvim/plugged')
Plug 'chrisbra/Colorizer'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-scripts/greenvision'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'pgdouyon/vim-yin-yang'
Plug 'cormacrelf/vim-colors-github'
Plug 'NLKNguyen/papercolor-theme'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'kemiller/vim-ir_black'
Plug 'shirk/vim-gas'
Plug 'ParamagicDev/vim-medic_chalk'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
let g:javascript_plugin_flow = 1 
Plug 'pangloss/vim-javascript'
Plug 'djoshea/vim-autoread'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
call plug#end()
set hidden
autocmd BufRead,BufNewFile *.js.flow set filetype=javascript
autocmd BufRead,BufNewFile *.abo set filetype=abo tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd BufRead,BufNewFile *.A set filetype=nasm
autocmd FocusLost,BufLeave * nested silent! wall
autocmd UIEnter * Guifont! Terminus:h16:b

set hidden
set signcolumn=yes
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['clangd', '--all-scopes-completion','--header-insertion=never'],
    \ 'c': ['clangd', '--all-scopes-completion','--header-insertion=never'],
    \ 'javascript': ['flow', 'lsp'],
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
if has("termguicolors")     " set true colors
  set termguicolors
endif


if strftime("%H") < 19
  set background=light
  colo PaperColor
else
  set background=dark
  colo solarized8_flat
endif

let mapleader = ' '
nnoremap <silent> <C-s> :w<CR>
"nnoremap <silent> <C-z> :Files<CR>
" nnoremap <silent> <Leader>q :bd!<CR>
nnoremap <silent> <Leader>s :wall\|Gstatus<CR>
nnoremap <silent> <Leader>q :bd!<CR>
nnoremap <silent> <Leader>n :bnext<CR>
nnoremap <silent> <Leader>N :bprevious<CR>

nnoremap <silent> <Leader>t :wall\|tabnew term://flow<CR>

nnoremap <silent> <Leader>c :wall\|tabnew term://clang $(cat compile_flags.txt) -fsyntax-only %<CR>
nnoremap <silent> <Leader>r :wall\|tabnew term://clang $(cat compile_flags.txt ./%:r.link_flags.txt) % -o ./%:r.out;./%:r.out<CR>
nnoremap <silent> <Leader>d :wall\|tabnew term://clang $(cat compile_flags.txt ./%:r.link_flags.txt) -g  % -o ./%:r.out;lldb ./%:r.out<CR>
nnoremap <silent> <Leader>C :wall\|tabnew term://clang++ $(cat compile_flags.txt) -fsyntax-only %<CR>
nnoremap <silent> <Leader>R :wall\|tabnew term://clang++ $(cat compile_flags.txt ./%:r.link_flags.txt) % -o ./%:r.out;./%:r.out<CR>
nnoremap <silent> <Leader>D :execute "vsplit term://flow get-def %"." ".line('.')." ".col('.')<CR>
"nnoremap <silent> K :execute "vsplit term://flow type-at-pos %"." ".line('.')." ".col('.')<CR>

nnoremap <silent> <Leader><space> yiw:Ag "<CR>

set path+=**
set number
set mouse=nv
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set copyindent
set splitright
set splitbelow
set noshowmode
if has('nvim')
  set inccommand=nosplit
endif
set showcmd
set nobackup
set noswapfile
set autoread
set nohlsearch
set updatetime=100
set nowrap
set laststatus=0

set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c

