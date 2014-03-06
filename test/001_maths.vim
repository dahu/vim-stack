call vimtest#StartTap()
call vimtap#Plan(8) " <== XXX  Keep plan number updated.  XXX

let x = _S.push(10).push(10).add().top()
call vimtap#Is(x, 20, 20, 'add')

let x = _S.push(5).sub().top()
call vimtap#Is(x, 15, 15, 'sub')

let x = _S.push(5).div().top()
call vimtap#Is(x, 3, 3, 'div')

let x = _S.push(2).fdiv().top()
call vimtap#Is(x, 1.5, 1.5, 'fdiv')

let x = _S.push(4).mul().top()
call vimtap#Is(x, 6, 6, 'mul')

let x = _S.push(3).mod().top()
call vimtap#Is(x, 0, 0, 'mod')

let x = _S.flush().push(1).push(2).push(3).push(4).push(5).nsum(3).top()
call vimtap#Is(x, 12, 12, 'nsum')

let x = _S.flush().push(1).push(2).push(3).push(4).push(5).sumall().top()
call vimtap#Is(x, 15, 15, 'sumall')

call vimtest#Quit()
