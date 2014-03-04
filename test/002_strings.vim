call vimtest#StartTap()
call vimtap#Plan(5) " <== XXX  Keep plan number updated.  XXX

let x = _S.push(10).push(10).join().top()
call vimtap#Is(x, '1010', '1010', 'join')

let x = _S.push(10).push(10).join(' ').top()
call vimtap#Is(x, '10 10', '10 10', 'join with sep')

call _S.flush() " start with a fresh stack
let x = _S.pusheach(split("one two three four")).joinall(', ').top()
call vimtap#Is(x, "one, two, three, four", "one, two, three, four", 'joinall')

" an alternative is to use Stack's .split().explode()

let x = _S.push("one two three four").split().explode().njoin(3, '-').top()
call vimtap#Is(x, "two-three-four", "two-three-four", 'njoin')

let x = _S.push("hello").len().top()
call vimtap#Is(x, 5, 5, 'len')

call vimtest#Quit()
