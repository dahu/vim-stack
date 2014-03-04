function! Run(n)
  call g:_S.flush()
  call g:_S.push(getline(a:n,'$')).slice(5)
  %delete
  call append(0, map(g:_S.s(), 'join(v:val, "\t")'))
endfunction

call Run(search('^\s*fini\%[sh]', 'n')+1)
finish
one
two
three
four
five
a
b
c
d
e
1
2
3
4
5
