" =======================================================================
" Author:	Louie Jin <767508270@qq.com>
" Copyright (C) 2016 Louie Jin
" Last modified:	2016-03-02 21:33
" Filename:	.vimrc
" Description:
"========================================================================
"
"------------------------ bundle config ----------------------------
set nocompatible	" be improved
filetype off		" required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let vundle manage vundle, required!
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
Plugin 'VundleVim/Vundle.vim'

" vim-powerline bundle {
	set laststatus=2
	set t_Co=256
	let g:Powerline_symbols = 'unicode'
	set encoding=utf8
	Plugin 'Lokaltog/vim-powerline.git'
" }

" the nerd tree bundle {
	Plugin 'The-NERD-tree'
" }
"
" ctrlspace bundle {
	Plugin 'szw/vim-ctrlspace'
" }
"
" vim-multiple-cursors {
	Plugin 'terryma/vim-multiple-cursors'
" }
"
" vim-colors-solarized {
	let g:solarized_termcolors = 256
	let g:solarized_termtrans = 1
	let g:solarized_contrast = "normal"
	let g:solarized_visibility = "normal"
	Plugin 'altercation/vim-colors-solarized'
" }
"
" YouCompleteMe {
	Plugin 'Valloric/YouCompleteMe'
" }
" taglist bundle {
	" let Tlist_Ctags_Cmd='/usr/bin/ctags' 	" associate taglist with ctags
	let Tlist_Show_Menu = 1
	let Tlist_Show_One_File = 1
	let Tlist_Exit_OnlyWindow = 1
	let Tlist_File_Fold_Auto_Close = 1
	Plugin 'taglist.vim'
" }

" winmanager bundle {
	let g:winManagerWindowLayout = 'FileExplorer|TagList'
	let g:winManagerWidth = 25
	let g:AutoOpenWinManager = 1 		" open winmanager while enter vim
	Plugin 'winmanager'
" }

" my bundles here:

" required plugins available after
call vundle#end()
filetype plugin indent on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" bundle map {
	nmap <silent> <F8> :WMToggle<CR>
	nmap <silent> <F10> :NERDTreeToggle<CR>
" }

" ----------------------- my config ---------------------------
" General { 
	set nocompatible                " Must be first line
	set background=dark             " Assume a dark background
	filetype plugin indent on       " Automatically detect file types.
	syntax on                       " Syntax highlighting
	scriptencoding utf-8
	"set spell                     " Spell checking on
	set hidden                      " Allow buffer switching without saving
	set iskeyword-=.                " '.' is an end of word designator
	set iskeyword-=#                " '#' is an end of word designator
	set iskeyword-=-                " '-' is an end of word designator
" }

" Vim UI { 
	color solarized                 " Load a colorscheme
	set tabpagemax=15               " Only show 15 tabs
	set cursorline                  " Highlight current line
	highlight clear SignRow
	" hi CursorLine   cterm=underline ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
	set cursorcolumn                " Highlight currnet column
	highlight clear SignColumn      " SignColumn should match background
	" hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=NONE  guibg=darkred guifg=NONE
	set showcmd                     " Show partial commands in status line and
	set backspace=indent,eol,start  " Backspace for dummies
	set number                      " Line numbers on
	highlight clear LineNr          " Current line number row will have same background color in relative mode
	set showmatch                   " Show matching brackets/parenthesis
	set incsearch                   " Find as you type search
	set hlsearch                    " Highlight search terms
	set winminheight=0              " Windows can be 0 line high
	set ignorecase                  " Case insensitive search
	set smartcase                   " Case sensitive when uc present
	set wildmenu                    " Show list instead of just completing
	set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
	set whichwrap=b,s,<,>,[,]       " Backspace and cursor keys wrap too
	set scrolljump=5                " Lines to scroll when cursor leaves screen
	set scrolloff=3                 " Minimum lines to keep above and below cursor
	set foldenable                  " Auto fold code
	set foldmethod=marker
	set list
	set listchars=tab:>-,eol:<,trail:-,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
	set autoindent                  " Indent at the same level of the previous line
	set splitright                  " Puts new vsplit windows to the right of the current
	set splitbelow                  " Puts new split windows to the bottom of the current
	set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType c,cpp,lua setlocal textwidth=80 formatoptions+=t
	" Remove trailing whitespaces and ^M chars
	autocmd FileType c,cpp,java,javascript,python,lua
		\ autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }

" Functions {
	" {{ begin of HighlightWord
	let g:auto_highlight_word_enabled = 0
	let g:cur_hightlight_word = ""
	function! HighlightWord(word)
		hi highlightWord term=bold ctermfg=blue ctermbg=yellow guifg=red guibg=#FFFF00
		let l:cmd = 'match highlightWord /\<\V' . a:word . '\>/'
		execute l:cmd
		let @/ = a:word
	endfunction
	function! AutoHighLight()
		let l:word = expand("<cword>")
		if l:word != "" && l:word != "/" && l:word != "\\"
			if l:word == g:cur_hightlight_word
				return
			end 
			let g:cur_hightlight_word = l:word
			call HighlightWord(g:cur_hightlight_word)
		endif
	endfunction
	function! AutoHighLightToggle()
		if g:auto_highlight_word_enabled == 0
			let g:auto_highlight_word_enabled = 1
			call AutoHighLight()
			echo "Auto Hightlight ON"
		else
			let g:auto_highlight_word_enabled = 0
			let g:cur_hightlight_word = ""
			match none
			echo "Auto Hightlight OFF"
		endif
	endfunction
	" }} begin of HighlightWord

	" Strip whitespace {
	function! StripTrailingWhitespace()
		" Preparation: save last search, and cursor position.
		let _s=@/
		let l = line(".")
		let c = col(".")
		" do the business:
		%s/\s\+$//e
		" clean up: restore previous search history, and cursor position
		let @/=_s
		call cursor(l, c)
	endfunction
	" }
" }

" Key (re)Mappings {
	map L gt
	map H gT
	map <C-J> <C-W>j
	map <C-K> <C-W>k
	map <C-H> <C-W>h
	map <C-L> <C-W>l

	map <space> :nohlsearch<cr>:call AutoHighLightToggle()<cr>
" }
