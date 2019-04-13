call plug#begin('~/.vim/plugged')

 " Appearance
Plug 'mkitt/tabline.vim'                     " Cleaner tabs
Plug 'chrisbra/Colorizer'                    " Show hex codes as colours
Plug 'unblevable/quick-scope'                " Highlight jump characters
Plug 'itchyny/lightline.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'Yggdroot/indentLine'
let g:indentLine_faster = 1
Plug 'maximbaz/lightline-ale'
Plug 'posva/vim-vue'
Plug 'LnL7/vim-nix'

 " Features
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'pangloss/vim-javascript'
Plug 'w0rp/ale'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'sourcegraph/javascript-typescript-langserver'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/vim-peekaboo'
Plug 'airblade/vim-gitgutter'

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'                       " Fzf vim plugin
Plug 'vimwiki/vimwiki'

call plug#end()

let g:deoplete#enable_at_startup = 1
let g:ale_completion_enabled = 0

let g:indentLine_fileTypeExclude = ['json']

let mapleader = "\<Space>"

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set pastetoggle=<F2>
set nowrap
set scrolloff=5
" always show status bar at the bottom
set laststatus=2
" show search results as you type, highlight throughout the file, case-insensitive search
set hlsearch
set incsearch
set ignorecase smartcase
" Required for operations modifying multiple buffers like rename.
set hidden
set autoread
" Keep the cursor on the same column
set nostartofline

set colorcolumn=80
set t_Co=16
set signcolumn=yes
" do not automatically add EOL symbol to open files
" set nofixeol

" show trailing spaces and show tabs differently
set listchars=tab:>-,nbsp:+,trail:~
set list
set showbreak=↪\

set background=dark
colorscheme solarized

" black hole register mappings
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d
nnoremap <leader>w :update<cr>

" Make Y behave like other capitals
map Y y$
" qq to record, Q to replay
nnoremap Q @q
" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" Appearance
syntax on
filetype plugin indent on
set tabstop=2
set softtabstop=2
set shiftwidth=2
autocmd FileType javascript,python,html,haskell set expandtab

highlight LineNr ctermfg=10

" ----------------------------------------------------------------------------
" FZF
" ----------------------------------------------------------------------------
map <leader>/ :Rg<Cr>
nmap <C-p> :Files<cr>
nnoremap <silent> <M-p> :Buffers<cr>

let g:rg_command = '
\ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
\ -g "*.{ts,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
\ -g "!{.config,.git,node_modules,bower_components,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '

command! -bang -nargs=* Rg call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~60%' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" ----------------------------------------------------------------------------
" ALE & LSP
" ----------------------------------------------------------------------------
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'html': ['htmlhint'],
\   'python': ['flake8'],
\   'haskell': ['stack_build'],
\}
let g:ale_fixers = {
\  'haskell': ['brittany'],
\}
let g:ale_lint_delay = 1000
let g:ale_javascript_eslint_options = '-c ~/.eslintrc.js'

let g:ale_set_highlights = 0
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['/usr/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ }
let g:LanguageClient_useVirtualText = 0

nnoremap <silent><Leader>gd :call LanguageClient#textDocument_definition()<CR>

augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.html set filetype=javascript.html
augroup END

" ----------------------------------------------------------------------------
" LIGHTLINE
" ----------------------------------------------------------------------------
function! LightLineFilename()
  return expand('%')
endfunction

function LightlineObsession()
    return ObsessionStatus('◼', '▮▮')
endfunction

function! GitInfoVisible()
    let l:hunks = GitGutterGetHunkSummary()
    if l:hunks[0] || l:hunks[1] || l:hunks[2]
        return '(+' . l:hunks[0] . ' ~' . l:hunks[1] . ' -' . l:hunks[2] . ')'
    endif
endfunction

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'lineinfo' ],
      \              [ 'changes', 'obsession', 'percent', 'filetype', 'fileencoding', 'fileformat' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightLineFilename',
      \   'changes': 'GitInfoVisible',
      \   'obsession': 'LightlineObsession',
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"x":""}',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' },
      \ }
