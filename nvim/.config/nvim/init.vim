call plug#begin('~/.vim/plugged')

 " Appearance
Plug 'chrisbra/Colorizer'                    " Show hex codes as colours
Plug 'unblevable/quick-scope'                " Highlight jump characters
Plug 'itchyny/lightline.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'Yggdroot/indentLine'
Plug 'leafgarland/typescript-vim'
let g:indentLine_faster = 1
Plug 'maximbaz/lightline-ale'
Plug 'LnL7/vim-nix'
Plug 'mbbill/undotree'

 " Features
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'pangloss/vim-javascript'
Plug 'w0rp/ale'
Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/vim-peekaboo'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'                       " Fzf vim plugin
Plug 'vimwiki/vimwiki'

Plug 'neovimhaskell/haskell-vim'
Plug 'itchyny/vim-haskell-indent'

call plug#end()

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
set inccommand=nosplit
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

" Maintain undo history between sessions
set undofile
set undodir=~/.config/nvim/undodir

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
set expandtab

highlight LineNr ctermfg=10

autocmd FileType javascript.html setlocal commentstring=<!--\ %s\ -->

" ----------------------------------------------------------------------------
" FZF
" ----------------------------------------------------------------------------
map <leader>/ :Rg<Cr>
nmap <C-p> :Files<cr>
nnoremap <silent> <M-p> :Buffers<cr>

let g:rg_command = '
\ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
\ -g "*.{ts,js,json,md,less,pug,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,nix}"
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
\   'svelte': ['javascript'],
\   'html': ['htmlhint'],
\   'python': ['flake8'],
\   'haskell': ['stack_build'],
\}

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent><Leader>gd <Plug>(coc-definition)
nmap <silent><Leader>gt <Plug>(coc-type-definition)
nmap <silent><Leader>gi <Plug>(coc-implementation)

" Use t to show documentation in preview window
nnoremap <silent><Leader>t :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let g:ale_lint_delay = 1000
let g:ale_javascript_eslint_options = '-c ~/.eslintrc.js'

let g:ale_set_highlights = 0

augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.html set filetype=javascript.html
augroup END

au BufNewFile,BufRead,BufReadPost *.svelte set filetype=javascript.html

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
