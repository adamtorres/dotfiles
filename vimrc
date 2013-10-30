execute pathogen#infect()
syntax on
filetype plugin indent on

set background=dark
colorscheme solarized
let mapleader=","

" let g:syntastic_python_checkers=['pep8']
" let g:syntastic_python_checkers=['pylint']
" let g:syntastic_python_checkers=['pylama']
" let g:syntastic_python_checkers=['pyflakes']
" let g:syntastic_python_checkers=['py3kwarn']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_stl_format="[%E{%e Errors} %B{, }%W{%w Warnings}]"

set cursorline
set ignorecase      " ignore case when searching
set modeline        " last lines in document sets vim mode
set modelines=3     " number lines checked for modelines
set noerrorbells
set notitle         " don't show "Thanks for flying vim"
set nowrap          " stop lines from wrapping
set number
set numberwidth=4   " line numbering takes up 5 spaces
set shortmess=atI   " Abbreviate messages
set ttyfast         " smoother changes
set visualbell
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" set cursorline to center vertically
set so=9999

" Clear search by hitting space
" nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Clear search by hitting enter
:nnoremap <CR> :nohlsearch<cr>

" show extraneous spaces and where tabs are
set list listchars=tab:>.,trail:·,eol:¬ " mark trailing white space

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" more informative status line
if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Start the status line
  set statusline=%F%m%r%h%w

  " Add fugitive
  set statusline+=\ %{fugitive#statusline()}

  set statusline+=\ [ASC=\%03.3b]\ [#=\%02.2B]\ [%p%%]\ [%4v]

  " Add syntastic if enabled
  set statusline+=\ %#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
endif
