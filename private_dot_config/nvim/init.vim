" Basic Neovim config for chezmoi management
set number relativenumber
set ignorecase smartcase
set clipboard=unnamedplus
set wrap
syntax on
filetype plugin indent on
" Go-specific settings:
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
" Basic LSP setup for Go
autocmd FileType go lua vim.lsp.start({name = 'gopls', cmd = {'gopls'}, root_dir = vim.fs.dirname(vim.fs.find({'go.mod', '.git'}, {upward = true})[1])})
" LSP keymaps (only active for Go files)
autocmd FileType go nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<CR>
autocmd FileType go nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<CR>
autocmd FileType go nnoremap <buffer> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
autocmd FileType go nnoremap <buffer> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
autocmd FileType go nnoremap <buffer> ]d <cmd>lua vim.diagnostic.goto_next()<CR>
autocmd FileType go nnoremap <buffer> [d <cmd>lua vim.diagnostic.goto_prev()<CR>
" Enable basic completion (Ctrl+X Ctrl+O)
set omnifunc=v:lua.vim.lsp.omnifunc
