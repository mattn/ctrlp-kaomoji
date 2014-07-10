scriptencoding utf-8

if exists('g:loaded_ctrlp_kaomoji') && g:loaded_ctrlp_kaomoji
  finish
endif
let g:loaded_ctrlp_kaomoji = 1

let s:kaomoji_var = {
\  'init':   'ctrlp#kaomoji#init()',
\  'exit':   'ctrlp#kaomoji#exit()',
\  'accept': 'ctrlp#kaomoji#accept',
\  'lname':  'kaomoji',
\  'sname':  'kaomoji',
\  'type':   'path',
\  'sort':   0,
\  'nolim':  1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:kaomoji_var)
else
  let g:ctrlp_ext_vars = [s:kaomoji_var]
endif

let s:datafile = expand('<sfile>:h:h:h') . '/data/2ch_ver1.txt'
let s:mode = ''
let s:col = 0
let s:list = []

function! ctrlp#kaomoji#init()
  if !filereadable(s:datafile)
    call system('curl -s "http://kaosute.net/jisyo/pdf2.cgi?file=2ch_ver1&method=download" > ' . shellescape(s:datafile))
  endif
  let s:list = filter(split(iconv(join(readfile(s:datafile), "\n"), 'cp932', &encoding), "\n"), 'v:val !~ "^!" && v:val !~ "かおすて"')
  return map(copy(s:list), 'join(split(v:val, "\t")[:1], "\t")')
endfunc

function! ctrlp#kaomoji#accept(mode, str)
  call ctrlp#exit()
  let line = getline('.')
  let pos = s:mode == 'i' ? s:col + 1 : s:col
  let line = line[:pos] . a:str . line[pos+1:]
  call setline('.', line)
  if s:mode == 'i'
    call feedkeys('a')
  endif
endfunction

function! ctrlp#kaomoji#exit()
  if exists('s:list')
    unlet! s:list
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#kaomoji#id()
  return s:id
endfunction

function! ctrlp#kaomoji#start(mode)
  let s:mode = a:mode
  let g:moge = s:mode
  let s:col = col('.')
  call ctrlp#init(ctrlp#kaomoji#id())
  return ''
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
