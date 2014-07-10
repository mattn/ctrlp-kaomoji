if &cp || (exists('g:loaded_kaomoji_vim') && g:loaded_kaomoji_vim)
  finish
endif
let g:loaded_kaomoji_vim = 1

let s:save_cpo = &cpo
set cpo&vim

command! Kaomoji cal ctrlp#kaomoji#start('n')

if get(g:, 'kaomoji_key', '') == ''
  nnoremap <plug>(kaomoji) :call ctrlp#kaomoji#start('n')<cr>
  inoremap <plug>(kaomoji) <c-r>=ctrlp#kaomoji#start('i')<cr>
  nmap <unique> <c-1> <plug>(kaomoji)
  imap <unique> <c-1> <plug>(kaomoji)
else
  exe "nnoremap" g:kaomoji_key ":call ctrlp#kaomoji#start('n')<cr>"
  exe "inoremap" g:kaomoji_key "<c-r>=ctrlp#kaomoji#start('i')<cr>"
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
