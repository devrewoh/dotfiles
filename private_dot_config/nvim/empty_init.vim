" Basic Neovim config for chezmoi management
set number relativenumber
set ignorecase smartcase
set clipboard=unnamedplus
syntax on
filetype plugin indent on

" Go-specific settings:
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab

" Commonly changed settings (uncomment as needed):
" set background=dark
" colorscheme desert
" set wrap
" set mouse=a
" set cursorline
" set scrolloff=8
