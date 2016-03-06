" =======================================================================
" Author:	Ray Kim <767508270@qq.com>
" Copyright (C) 2016 Ray Kim
" Last modified:	2016-03-02 21:33
" Filename:	.vimrc
" Description:
"========================================================================
"
" Environment {
"
" }
"
" General { 
	set nocompatible                " Must be first line
	set background=dark             " Assume a dark background
	filetype plugin indent on       " Automatically detect file types.
	syntax on                       " Syntax highlighting
	scriptencoding utf-8
	" set spell                       " Spell checking on
	set hidden                      " Allow buffer switching without saving
	set iskeyword-=.                " '.' is an end of word designator
	set iskeyword-=#                " '#' is an end of word designator
	set iskeyword-=-                " '-' is an end of word designator
" }

" Vim UI {

	set tabpagemax=15               " Only show 15 tabs
	set showmode                    " Display the current mode
	set cursorline                  " Highlight current line
	
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
	set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
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
	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType c,cpp,lua setlocal textwidth=80 formatoptions+=t
	" Remove trailing whitespaces and ^M chars
	autocmd FileType c,cpp,java,javascript,python,lua
		\ autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }

" Key (re)Mappings {
	" Don't use Ex mode, use Q for formatting
	map Q gq
	map L gt
	map H gT
	map <C-J> <C-W>j
	map <C-K> <C-W>k
	map <C-H> <C-W>h
	map <C-L> <C-W>l

	map <space> :nohlsearch<cr>:call AutoHighLightToggle()<cr>
" }
"
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

