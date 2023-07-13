call plug#begin('~/.vim/plugged')

 " Appearance
Plug 'chrisbra/Colorizer'                    " Show hex codes as colours
Plug 'itchyny/lightline.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'Yggdroot/indentLine'
let g:indentLine_faster = 1
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

 " Features
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/vim-peekaboo'
Plug 'airblade/vim-gitgutter'
Plug 'unblevable/quick-scope'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'                       " Fzf vim plugin
Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
Plug 'andymass/vim-matchup'

call plug#end()

let g:indentLine_fileTypeExclude = ['json']

let mapleader = "\<Space>"

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set shell=bash
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
set cursorline

set colorcolumn=100
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

let g:vim_json_conceal=0

" set background=light
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

" set number relativenumber
" set numberwidth=2

" highlight LineNr ctermfg=10
" highlight clear LineNr

autocmd FileType javascript.html setlocal commentstring=<!--\ %s\ -->
autocmd BufRead,BufNewFile *.md setlocal spell

if executable('/usr/local/bin/rg')
  set grepprg=\/usr\/local\/bin\/rg\ --vimgrep\ --hidden
endif

" ----------------------------------------------------------------------------
" FZF
" ----------------------------------------------------------------------------
map <leader>/ :Rg<Cr>
nmap <C-p> :Files<cr>
nnoremap <silent> <M-p> :Buffers<cr>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -g "*.{ts,tsx,scss}" -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%'), <bang>0)

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~80%' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Remap keys for gotos
nmap <silent><Leader>gd <Plug>(coc-definition)
nmap <silent><Leader>gt <Plug>(coc-type-definition)
nmap <silent><Leader>gi <Plug>(coc-implementation)
nmap <silent><Leader>gr <Plug>(coc-references)
highlight CocFloating ctermbg=7


" Use t to show documentation in preview window
nnoremap <silent><Leader>t :call <SID>show_documentation()<CR>
" nnoremap <Leader>p :silent %!npx prettier --stdin-filepath %<CR>
nnoremap <Leader>p :call CocAction('runCommand', 'eslint.executeAutofix')<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

highlight! link SignColumn LineNr

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

hi MatchParen ctermbg=black guibg=lightblue cterm=italic gui=italic
