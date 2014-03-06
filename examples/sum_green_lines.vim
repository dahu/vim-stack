" Sums together the numbers of only the lines containing 'green'

function! Run(n)
  call g:_S.flush()
  call g:_S.push(GCollect('green')).matchstr('\d\+').sum()
  call append('$', g:_S.top())
endfunction

call Run(search('^\s*fini\%[sh]', 'n')+1)
finish
red     11  food
green   12  food
blue    13  food
green   14  food
orange  15  food
