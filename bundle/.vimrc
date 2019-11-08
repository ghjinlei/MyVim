" =======================================================================
" Author:	Louie Jin <767508270@qq.com>
" Copyright (C) 2016 Louie Jin
" Last modified:	2016-03-02 21:33
" Filename:	.vimrc
" Description:
"========================================================================

" Environment {
	" Identify platform {
	silent function! OSX()
		return has('macunix')
	endfunction
	silent function! LINUX()
		return has('unix') && !has('macunix') && !has('win32unix')
	endfunction
	silent function! WINDOWS()
		return  (has('win32') || has('win64'))
	endfunction
	" }
	"
	" Basics {
	set nocompatible        " Must be first line
	let mapleader=","
	" }

	" Platform compatible {
	if WINDOWS()
		set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
		set lines=50 columns=200
	endif
	" }
" }

" Use bundles config {
	if filereadable(expand("$HOME/.vimrc.bundle"))
		source ~/.vimrc.bundle
	endif
" }

" General {
	filetype plugin indent on       " Automatically detect file types.
	syntax on                       " Syntax highlighting
	scriptencoding utf-8
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=utf-8,ucs-bom,cp936
	set termencoding=utf-8

	set fileformats=unix,dos
	set fileformat=unix

	set hidden                      " Allow buffer switching without saving
	set iskeyword-=.                " '.' is an end of word designator
	set iskeyword-=#                " '#' is an end of word designator
	set iskeyword-=-                " '-' is an end of word designator

	set clipboard+=unnamed          " vim默认寄存器与系统寄存器共享
	set winaltkeys=no               " 设置alt键不映射到菜单栏

" Vim UI {
	set background=dark             " Assume a dark background
	color solarized                 " Load a colorscheme

	set guioptions-=m               " 关闭GUI菜单栏

	set tabpagemax=15               " Only show 15 tabs
	set showmode                    " Display the current mode

	set cursorline                  " Highlight current line
	set cursorcolumn                " Highlight currnet column
	hi clear SignColumn             " SignColumn should match background
	hi clear LineNr                 " Current Line number row will have same background color

	set ruler                       " Show the ruler
	set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
	set showcmd                     " Show partial commands in status line and

	set statusline=[%n]\ %t\ (%F)\ %m%r%h%w\ [%{&ff}]\ [%Y]\ [%l/%L,%v,%o]\ [%p%%]\ [0x%02.2B]

	set backspace=indent,eol,start  " Backspace for dummies
	set number                      " Line numbers on
	set showmatch                   " Show matching brackets/parenthesis
	set incsearch                   " Find as you type search
	set hlsearch                    " Highlight search terms
	set winminheight=0              " Windows can be 0 line high
	set ignorecase                  " Case insensitive search
	set smartcase                   " Case sensitive when uc present
	set wildmenu                    " Show list instead of just completing
	set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
	set whichwrap=b,s,<,>,[,]   " Backspace and cursor keys wrap too
	set scrolljump=5                " Lines to scroll when cursor leaves screen
	set scrolloff=3                 " Minimum lines to keep above and below cursor
	set foldenable                  " Auto fold code
	set foldmethod=marker
	set list
	set listchars=tab:>-,eol:<,trail:-,extends:# " Highlight problematic whitespace
" }

" Formatting {
	set autoindent                  " Indent at the same level of the previous line
	set splitright                  " Puts new vsplit windows to the right of the current
	set splitbelow                  " Puts new split windows to the bottom of the current
	set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

	" For all text files set 'textwidth' to 80 characters.
	autocmd FileType c,cpp,cs,java,javascript,python,lua
		\ setlocal textwidth=80 formatoptions+=t

	autocmd FileType c,cpp,cs,java,javascript,python
		\ setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab

	autocmd FileType lua
		\ setlocal shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab

	autocmd BufNewFile *.c,*.cpp,*.cs,*.java
		\exec ":call SetComment1()"

	autocmd BufNewFile *.lua 
		\exec ":call SetComment2()"
" }

" Key (re)Mappings {
	" Don't use Ex mode, use Q for formatting
	nnoremap Q gq
	nnoremap L gt
	nnoremap H gT
	nnoremap <C-J> <C-W>j
	nnoremap <C-K> <C-W>k
	nnoremap <C-H> <C-W>h
	nnoremap <C-L> <C-W>l

	nnoremap <leader>rj :resize -5<CR>
	nnoremap <leader>rk :resize +5<CR>
	nnoremap <leader>rh :vertical resize -5<CR>
	nnoremap <leader>rl :vertical resize +5<CR>

	inoremap <M-J> <Down>
	inoremap <M-K> <Up>
	inoremap <M-H> <Left>
	inoremap <M-L> <Right>

	inoremap <C-BS> <ESC>bdei
	inoremap ( ()<ESC>i
	inoremap [ []<ESC>i
	inoremap { {}<ESC>i
	inoremap " ""<ESC>i
	inoremap ' ''<ESC>i

	cnoremap <C-A> <HOME>
	cnoremap <C-E> <END>

	map <space> :nohlsearch<cr>:call AutoHighLightToggle()<cr>
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

	" insert comment: c, cpp, ... {
	function! SetComment1()
		call append(0, "\/*============================================================")
		call append(1, "* Copyright (C) " . strftime("%Y") . "Jin Lei")
		call append(2, "* ")
		call append(3, "* Path : " . expand("%"))
		call append(4, "* Author : jinlei")
		call append(5, "* CreateTime : " . strftime("$Y-%m-%d %H:%M:%S"))
		call append(6, "* Description :")
		call append(7, "* ")
		call append(8, "========================================================*/")
	endfunction
	" }

	" insert comment: lua {
	function! SetComment2()
		call append(0, "--[[")
		call append(1, "ModuleName :")
		call append(2, "Path : " . expand("%"))
		call append(3, "Author : jinlei")
		call append(4, "CreateTime : " . strftime("%Y-%m-%d %H:%M:%S"))
		call append(5, "Description :")
		call append(6, "--]]")
	endfunction
	" }
" }

" Use other config {
	if filereadable(expand("$HOME/.vimrc.other"))
		source ~/.vimrc.other
	endif
" }
