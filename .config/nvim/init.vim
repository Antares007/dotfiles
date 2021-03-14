call plug#begin('~/.config/nvim/plugged')
Plug 'liuchengxu/vim-which-key'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'mfussenegger/nvim-dap'

Plug 'tomasiser/vim-code-dark'
Plug 'cormacrelf/vim-colors-github'
Plug 'NLKNguyen/papercolor-theme'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'kemiller/vim-ir_black'
Plug 'neovim/nvim-lspconfig'
let g:deoplete#enable_at_startup = 1
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
let g:javascript_plugin_flow = 1 
Plug 'pangloss/vim-javascript'
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
Plug 'mattn/emmet-vim'

Plug 'sbdchd/neoformat'
Plug 'djoshea/vim-autoread'
Plug 'scrooloose/nerdtree'
call plug#end()
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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
  indent = {
    enable = true
  }
}
EOF
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

lua << EOF 
require'lspconfig'.flow.setup{}
require'lspconfig'.clangd.setup{}
EOF 

lua << EOF
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
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
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
EOF

lua << EOF
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable';
  command = 'lldb-vscode';
  name = 'lldb';
  args = { };
  options = {
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = 'YES';
  };
}
EOF
lua << EOF
local dap = require('dap')
dap.configurations.c = {
  {
    type = 'lldb';
    request = 'launch';
    name = 'Launch file';
    program = '/${workspaceFolder}/${file}';
  },
}
EOF
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl :lua require'dap'.repl.run_last()<CR>

if has("termguicolors")     " set true colors
  set termguicolors
endif

set background=light
colorscheme darkblue

nnoremap <silent> <C-s> :w<CR>
"nnoremap <silent> <C-z> :Files<CR>
" nnoremap <silent> <Leader>q :bd!<CR>
nnoremap <silent> <Leader>n :wall\|vsplit term://node %<CR>
nnoremap <silent> <Leader>q :bd!<CR>
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

