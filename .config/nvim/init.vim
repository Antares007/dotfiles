call plug#begin('~/.config/nvim/plugged')
Plug 'jaredgorski/fogbell.vim'
Plug 'Mizux/vim-colorschemes'
Plug 'arzg/vim-colors-xcode'
Plug 'olivertaylor/vacme'
Plug 'liuchengxu/vim-which-key'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'norcalli/nvim-colorizer.lua'
Plug 'puremourning/vimspector'
let g:vimspector_enable_mappings = 'HUMAN'

Plug 'cormacrelf/vim-colors-github'
Plug 'NLKNguyen/papercolor-theme'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'kemiller/vim-ir_black'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
let g:javascript_plugin_flow = 1 
Plug 'pangloss/vim-javascript'
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}

Plug 'sbdchd/neoformat'
Plug 'djoshea/vim-autoread'
Plug 'scrooloose/nerdtree'
call plug#end()
set guifont=Terminus:h14
set hidden

autocmd BufRead,BufNewFile *.js.flow set filetype=javascript
autocmd BufRead,BufNewFile *.abo set filetype=abo tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd BufRead,BufNewFile *.A set filetype=nasm
autocmd FocusLost,BufLeave * nested silent! wall
autocmd BufWrite *.js Neoformat prettier
let mapleader = ' '
nnoremap <silent> <Leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

set hidden
set signcolumn=yes


lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { 'erlang', 'rust', 'gdscript','ocamllex', 'nix', 'ledger', 'gdscript', 'devicetree', 'supercollider', 'erlang' },  -- list of language that will be disabled
  },
  indent = {
    enable = true
  }
}
require'lspconfig'.flow.setup{}
require'lspconfig'.clangd.setup{}
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "clangd", "pyright", "rust_analyzer", "tsserver", "flow" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
EOF
if has("termguicolors")     " set true colors
  set termguicolors
endif
lua << EOF
require'colorizer'.setup()
EOF

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



set background=dark
colorscheme PaperColor
nnoremap <silent> <C-s> :w<CR>
nnoremap <silent> <Leader>n :silent wall\|vsplit term://node %<CR>
nnoremap <silent> <Leader>N :silent wall\|vsplit term://node b %<CR>
nnoremap <silent> <Leader>c :wall\|silent Neoformat\|vsplit term://make %:t:r && ./%:t:r<CR>
nnoremap <silent> <Leader>C :wall\|silent Neoformat\|vsplit term://make %:t:r -B && ./%:t:r<CR>
nnoremap <silent> <Leader>q :bd!<CR>
function! s:Clean()
    execute('silent! %s/^[\t ]*\#.*\n//e')
    execute('silent! %s/^[\t ]*\.\(text\|intel_syntax\|file\|globl\|p2align\|type\|cfi_\|Lfunc_end\|size\|section\|addrsig\|LFB\|LFE\).*\n//e')
    execute('silent! %s/^[\t ]\+/ /e')
    execute('silent! set tabstop=8')
    execute('silent! set ft=nasm')
    execute('silent! set nonumber')
    normal gg/^":
zt
endfunction
function! s:Dasm(cc, asmOpts, extraOpts)
    let n = escape(a:cc . ' ' . a:extraOpts, ' ')
    normal yiw
    execute('silent! write')
    execute('silent! Neoformat')
    execute('silent! !' . a:cc . ' ' . a:asmOpts . ' % ' . a:extraOpts . ' -o /tmp/' . n)
    execute('silent! vsplit /tmp/' . n)
    call s:Clean()
endfunction
function! g:Clang(options)
    call s:Dasm('clang', '-S -mllvm --x86-asm-syntax=intel', a:options)
endfunction
function! g:Gcc(options)
    call s:Dasm('gcc', '-S -masm=intel', a:options)
endfunction
nnoremap <silent> <Leader>0 :call g:Clang('-O0 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader>1 :call g:Clang('-O1 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader>2 :call g:Clang('-O2 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader>3 :call g:Clang('-O3 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader>) :call g:Gcc('-O0 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader>! :call g:Gcc('-O1 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader>@ :call g:Gcc('-O2 -fno-stack-protector -DNDEBUG')<CR>
nnoremap <silent> <Leader># :call g:Gcc('-O3 -fno-stack-protector -DNDEBUG')<CR>

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
