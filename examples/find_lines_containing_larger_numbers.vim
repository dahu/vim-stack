" Shows the lines containing numbers bigger than 50 (with line numbers)

function! Run(n)
  call g:_S.flush()
  call g:_S.pusheach(getline(1,'$'))
        \.mapall('[v:key+1, v:val]')
        \.filterall('v:val[1] =~ "\\d"')
        \.mapall('[v:val[0], map(split(substitute(v:val[1], "\\D\\+", " ", "g")), ''str2nr(v:val)'')]')
        \.filterall('filter(v:val[1], ''v:val > 50'') != []').s()
  call append('$', map(g:_S.s(), 'join(v:val, ": ")'))
endfunction

call Run(search('^\s*fini\%[sh]', 'n')+1)
finish
blah 10
20 blah
blah 30 blah 99
blah 40
50 blah

blah 60 blah
blah 70
80 blah
blah 90 blah 100 blah
