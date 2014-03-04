call vimtest#StartTap()
call vimtap#Plan(7) " <== XXX  Keep plan number updated.  XXX

let x = _S.range(10, 20).top()
call vimtap#Is(x, range(10,20), 'range(10,20)', 'range and list')

unlet x
let x = _S.rangeeach(10, 20).list(5).top()
call vimtap#Is(x, range(16,20), 'range(15,20)', 'list(cnt)')

unlet x
call _S.flush()
let x = _S.range(1,5).range(1,5).map('nr2char(64+v:val)').zip(1).map('v:val[0] . v:val[1]').top()
call vimtap#Is(x, ['1A', '2B', '3C', '4D', '5E'], "['1A'...]", 'zip')

unlet x
call _S.flush()
" We eventually want 10 digits on the stack, but .map() operates on the TOS
" (expecting a list), so we just use .range() for the second set and then
" .explode() it to get the individual digits.
call _S.rangeeach(1,5).range(1,5).map('nr2char(64+v:val)').explode()
let x = _S.zipset(1).map('v:val[0] . v:val[1]').top()
call vimtap#Is(x, ['1A', '2B', '3C', '4D', '5E'], "['1A'...]", 'zip')

" again now without flushing the stack, so ['1A', '2B', ...] is on top
" and we want to avoid including that in the zipset
unlet x
call _S.rangeeach(1,5).range(1,5).map('nr2char(64+v:val)').explode()
let x = _S.zipset(1,5).map('v:val[0] . v:val[1]').top()
call vimtap#Is(x, ['1A', '2B', '3C', '4D', '5E'], "['1A'...]", 'zip')

" reverse the top element (a list) on the stack
unlet x
let x = _S.reverse().zip(':').top()
call vimtap#Is(x, ['1A:5E', '2B:4D', '3C:3C', '4D:2B', '5E:1A'], "['1A:5E'...]", 'zip')
call _S.flush()
unlet x
let x = _S.rangeeach(1,10).reverse(5).s()
call vimtap#Is(x, [1,2,3,4,5,10,9,8,7,6], "[1,2,3,4,5,10,9,8,7,6]", 'reverse(cnt)')

call vimtest#Quit()
