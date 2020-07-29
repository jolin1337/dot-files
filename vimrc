set nocompatible              " be iMproved, required
set encoding=utf-8
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'  " let Vundle manage Vundle, required

" Now some IDE stuff
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'

" And get dat highlighting and colors
Plugin 'altercation/vim-colors-solarized'
Plugin 'jparise/vim-graphql'
Plugin 'elzr/vim-json'

" Prettier for javascript
Plugin 'prettier/vim-prettier'

" Airline {{{
	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-airline/vim-airline-themes'
	let g:airline_powerline_fonts=1
	let g:airline_left_sep=''
	let g:airline_right_sep=''
	let g:airline_theme='base16'
	let g:airline#extensions#tabline#show_splits = 0
	let g:airline#extensions#whitespace#enabled = 0
	" enable airline tabline
	let g:airline#extensions#tabline#enabled = 1
	" only show tabline if tabs are being used (more than 1 tab open)
	let g:airline#extensions#tabline#tab_min_count = 2
	" do not show open buffers in tabline
	let g:airline#extensions#tabline#show_buffers = 0
" }}}

call vundle#end()            " required
filetype plugin indent on    " required

" YouCompleteMe stuffs
autocmd CmdwinEnter * inoremap <expr><buffer> <TAB>
      \ pumvisible() ? "\<C-n>" : "\<TAB>"

let g:ycm_key_list_select_completion = ['<TAB>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" Prettier auto-format
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1

" NERDtree things
let g:nerdtree_tabs_open_on_console_startup=1
let g:NERDTreeWinSize = 40
"let NERDTreeMapOpenInTab='<ENTER>'
nmap \ :NERDTree<CR>
nmap <S-\> :NERDTreeTabsToggle<CR>

" Extra mappings for things like iTerm
map 1;5A <C-Up>
map 1;5B <C-Down>
map 1;5C <C-Right>
map 1;5D <C-Left>
map ^[1;5E <C-.>
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>
nmap <silent> <C-.> :YcmCompleter GetDoc<CR>


" General Mappings {{{
	" set a map leader for more key combos
	let mapleader = ','

	" wipout buffer
	nmap <silent> <leader>b :bw<cr>

	" shortcut to save
	nmap <leader>, :w<cr>

	" set paste toggle
	set pastetoggle=<leader>v

	" edit ~/.config/nvim/init.vim
	map <leader>ev :e! ~/.config/nvim/init.vim<cr>
	" edit gitconfig
	map <leader>eg :e! ~/.gitconfig<cr>

	" clear highlighted search
	noremap <space> :set hlsearch! hlsearch?<cr>

	" activate spell-checking alternatives
	nmap ;s :set invspell spelllang=en<cr>

	" remove extra whitespace
	nmap <leader><space> :%s/\s\+$<cr>
	nmap <leader><space><space> :%s/\n\{2,}/\r\r/g<cr>

	nmap <leader>l :set list!<cr>

	" Textmate style indentation
	vmap <leader>[ <gv
	vmap <leader>] >gv
	nmap <leader>[ <<
	nmap <leader>] >>

	" switch between current and last buffer
	nmap <leader>. <c-^>

	" Search for visually selected text
	vnoremap <leader>/ y/\V<C-r>=escape(@",'/\')<CR><CR>

	map <silent> <C-h> :call functions#WinMove('h')<cr>
	map <silent> <C-j> :call functions#WinMove('j')<cr>
	map <silent> <C-k> :call functions#WinMove('k')<cr>
	map <silent> <C-l> :call functions#WinMove('l')<cr>
	map <leader>wc :wincmd q<cr>

	" search for word under the cursor
	nnoremap <leader>/ "fyiw :/<c-r>f<cr>


" Timestamps
nnoremap <F5> "=strftime("%c -- ")<CR>P
inoremap <F5> <C-R>=strftime("%c -- ")<CR>

" powerline
"set term=xterm-256color
set laststatus=2

" Enable mouse if present
if has('mouse')
	set mouse=a
endif

" spacing and nicities
set expandtab shiftwidth=4 tabstop=4
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab
set number
set cursorline
set ruler
set nobackup nowb noswapfile
set background=dark
set bs=2
set scrolloff=15
syntax on
set t_Co=256

" Colorscheme and final setup {{{
	set background=dark
	if filereadable(expand("~/.vimrc_background"))
		let base16colorspace=256
		source ~/.vimrc_background
	else
		" let g:onedark_termcolors=256
		" let g:onedark_terminal_italics=1
		colorscheme solarized
	endif
	filetype plugin indent on
	" make the highlighting of tabs and other non-text less annoying
	highlight SpecialKey ctermfg=236
	highlight NonText ctermfg=236

	" make comments and HTML attributes italic
	highlight Comment cterm=italic
	highlight htmlArg cterm=italic
	highlight xmlAttrib cterm=italic
	highlight Type cterm=italic
	" highlight Normal ctermbg=none
" }}}


" goes to last line open in file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
