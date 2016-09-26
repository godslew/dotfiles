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
        " }}}

        " プラグイン以外のその他設定が続く
        " :

syntax on
colorscheme molokai
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
let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ }
""font

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

if dein#tap('vim-session')
function! s:save_session(...)
  if a:0
    let session_name = a:1
  else
    " fugitive.vimの機能を使っているのはブランチ名を取得する部分のみ
    " substitute(system('git rev-parse --abbrev-ref HEAD'), '\n', '', 'g')などで代替可能
    let session_name = substitute(system('git rev-parse --abbrev-ref HEAD'), '\n', '', 'g')
  end

  if strlen(session_name)
    execute 'SaveSession .'.session_name.'.session'
  else
    SaveSession
  endif
endfunction

function! s:load_session(...)
  if a:0
    let session_name = a:1
  else
    let session_name = substitute(system('git rev-parse --abbrev-ref HEAD'), '\n', '', 'g')
  end

  if strlen(session_name)
    execute 'OpenSession .'.session_name.'.session'
  else
    execute 'OpenSession '.g:session_default_name
  endif
endfunction
endif

command! -nargs=? SaveS call s:save_session(<f-args>)
command! -nargs=? LoadS call s:load_session(<f-args>)

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

