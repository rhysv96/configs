" Init plug
call plug#begin('~/.vim/plugged')

" NerdTree
Plug 'preservim/nerdtree'

" fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" commenter
Plug 'preservim/nerdcommenter'

" surround
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" typescript
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" vue
Plug 'posva/vim-vue'

" DBGP debugging (Xdebug, nodejs debugger..)
Plug 'vim-vdebug/vdebug'

" Sessioning, for restoring tmux
Plug 'tpope/vim-obsession'

" replace with register
Plug 'vim-scripts/ReplaceWithRegister'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'github/copilot.vim'

" Install plugins
call plug#end()


" Configuration
" enable deoplete (async autocomplete engine)
let g:deoplete#enable_at_startup = 1

" relative + absolute line numbers
set number relativenumber

" search highlighting
set nohlsearch
nnoremap <Leader>h :set hlsearch!<CR>

" NerdTree
let g:NERDTreeChDirMode = 2  " Change cwd to parent node
let g:NERDTreeMinimalUI = 1  " Hide help text
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>N :NERDTreeFind<CR>

" spaces
set expandtab
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2
autocmd Filetype js setlocal tabstop=2 shiftwidth=2
autocmd Filetype spec.js setlocal tabstop=2 shiftwidth=2
autocmd Filetype ts setlocal tabstop=2 shiftwidth=2
autocmd Filetype vue setlocal tabstop=2 shiftwidth=2
autocmd Filetype php setlocal tabstop=4 shiftwidth=4

" ts jumping
autocmd Filetype ts nnoremap <Leader>j :TSDef<CR>
autocmd Filetype ts nnoremap <Leader>J :TSDefPreview<CR>

" php jumping
autocmd Filetype php nnoremap <Leader>j :PhpactorGotoDefinition<CR>

" highlight trailing whitespace
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/

" FZF shortcuts
nnoremap <Leader>p :FZF<cr>
nnoremap <Leader>r :History<cr>

" vue preprocessors
let g:vue_pre_processors = [ 'scss' ]

" ale config (linting engine)
let g:ale_php_phpcbf_standard='PSR2'
let g:ale_php_phpcs_standard='phpcs.xml.dist'
let g:ale_php_phpmd_ruleset='phpmd.xml'
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'php': ['phpcbf', 'php_cs_fixer', 'remove_trailing_lines', 'trim_whitespace'],
  \}

" / searching options
" ignores case, unless a capital letter is used in the search
set smartcase ignorecase

let g:vdebug_options = {
  \ "port" : 9001,
  \ "server" : '',
  \ "timeout" : 20,
  \ "on_close" : 'detach',
  \ "break_on_open" : 0,
  \ "ide_key" : '',
  \ "path_maps" : {
  \     '/usr/src/app': getcwd()
  \ },
  \ "debug_window_level" : 0,
  \ "debug_file_level" : 0,
  \ "debug_file" : "",
  \ "watch_window_style" : 'compact',
  \ "marker_default"     : '⬦',
  \ "marker_closed_tree" : '▸',
  \ "marker_open_tree" : '▾'
  \}

" Mouse support
set mouse=a

" close tabs to the right
command -nargs=0 Tabr :.+1,$tabdo :q

" grab current file
command -nargs=0 Ycurr :let @+=expand("%")
