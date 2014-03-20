" Shows the lines containing numbers bigger than 50 (with line numbers)

function! Run(n)
  call g:_S.flush()
  call g:_S.pushline(1,'$').enumerate()
        \.filter('v:val[1] =~ "\\d"')
        \.unzip().extract('\d\+').zip(1)
        \.filter2('v:val > 50')
        \.unzip().map('join(v:val, ", ")').zip(": ")
  call append('$', g:_S.top())
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
