filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
autocmd FileType go autocmd BufWritePre <buffer> Fmt

exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
"CD
au   BufEnter *   execute ":lcd " . expand("%:p:h")
"--------------------
"" 基本的な設定
"--------------------
""新しい行のインデントを現在行と同じにする
set autoindent

"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/vimbackup

" "クリップボードをWindowsと連携する
set clipboard=unnamed

"vi互換をオフする
set nocompatible
"
"   "スワップファイル用のディレクトリを指定する
set directory=$HOME/vimbackup

"    "タブの代わりに空白文字を指定する
set expandtab
"
"     "変更中のファイルでも、保存しないで他のファイルを表示する
set hidden
"
"      "インクリメンタルサーチを行う
set incsearch
"
"       "行番号を表示する
set number

"閉括弧が入力された時、対応する括弧を強調する
set showmatch
"
" "新しい行を作った時に高度な自動インデントを行う
set smarttab

"backspace
set backspace=indent,eol,start

"tab 8 -> ?

"undodir
set undodir=$HOME/.vimundo
"  " grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh
"
"   " 検索結果のハイライトをEsc連打でクリアする
nnoremap <ESC><ESC> :nohlsearch<CR>
nnoremap <silent> <Leader>vi :<C-u>VimFiler -split -simple -winwidth=35 -no-quit<CR>
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1

augroup MyAutoCmd
        autocmd!
augroup END

" dein settings {{{
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
        call dein#load_toml(s:toml_file)
        call dein#end()
        call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
        call dein#install()
endif

syntax on
let g:go_fmt_autosave = 1
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <leader>b <Plug>(go-build)
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_interfaces = 1

augroup GolangSettings
        autocmd!
        autocmd FileType go nmap <leader>gb <Plug>(go-build)
        autocmd FileType go nmap <leader>gt <Plug>(go-test)
        autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
        autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
        autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
        autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
        autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
        autocmd FileType go :highlight goErr cterm=bold ctermfg=214
        autocmd FileType go :match goErr /\<err\>/
augroup END


"neocomplete setting"
let g:neocomplete#enable_at_startup = 1

""gocode
set completeopt=menu,preview

""lightline setting
colorscheme molokai
syntax on
""autofomatter
augroup autoformat_autocmd
        autocmd!
        ""au FileType *.ts nnoremap <Leader>f :<C-u>Autoformat<CR>
        au BufWrite *.ts :Autoformat
        au BufWrite *.html :Autoformat
augroup END
""vimsession
let g:session_default_name = '.default.session'
" session保持ファイルの拡張子
let g:session_extension = '.vim'
" session保存ディレクトリを現在のディレクトリにする
let g:session_directory = '~/.vimsessions/'
" vim終了時に自動保存しない
let g:session_autosave = 'no'
" 引数なしでvimを起動した時にセッションを復元しない
let g:session_autoload = 'no'
" 1分間に1回自動保存をしない(する場合は1)
let g:session_autosave_periodic = 0

""unite grep
nnoremap <silent> ,g  :<C-u>Unite grep/git:/. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep/git:/. -buffer-name=search-buffer<CR><C-R><C-W><CR>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>


" unite grepにhw(highway)を使う
if executable('hw')
        let g:unite_source_grep_command = 'hw'
        let g:unite_source_grep_default_opts = '--no-group --no-color'
        let g:unite_source_grep_recursive_opt = ''
endif

" git-vim
let g:git_bin = executable('hub') ? 'hub' : 'git'
let g:git_command_edit = 'vnew'
let g:git_no_default_mappings = 1
nnoremap gA :<C-U>GitAdd<Space>
nnoremap <silent>ga :<C-U>GitAdd<CR>
nnoremap gp :<C-U>Git push<Space>
nnoremap gD :<C-U>GitDiff<Space>
nnoremap gDD :<C-U>GitDiff HEAD<CR>
nnoremap git :<C-U>Git<Space>

" fugitive
nnoremap <silent>gM :Gcommit --amend<CR>
nnoremap <silent>gb :Gblame<CR>
nnoremap <silent>gB :Gbrowse<CR>
nnoremap <silent>gm :Gcommit<CR>

""vim-unite-giti
nnoremap <silent>gl :Unite giti/log -no-start-insert -horizontal<CR>
nnoremap <silent>gP :Unite giti/pull_request/base -no-start-insert -horizontal<CR>
nnoremap <silent>gs :Unite giti/status -no-start-insert -horizontal<CR>
nnoremap <silent>gh :Unite giti/branch_all -no-start-insert<CR>

"unite.vim
"" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
