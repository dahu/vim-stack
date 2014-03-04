" Utility Functions

" Zip(list_a, list_b, method)
"
" join each element of list a with the corresponding element of list b
" Use the third argument, method, to dictate how the elements should be
" combined:
" given: a = [a, b]
"        b = [1, 2]
" 0 = flattened list  : [a, 1, b, 2]
" 1 = list groups     : [[a, 1], [b, 2]]
" x = join separator x : [ax1, bx2]
"
" NOTE: If one list is longer than the other, the tail of that list is added
" to the result.
function! Zip(a, b, ...)
  let method = 1
  if a:0
    let method = a:1
  endif
  let i = 0
  let r = []
  let l_a = len(a:a)
  let l_b = len(a:b)
  let n = min([len(a:a), len(a:b)])
  while i < n
    if method == "0"
      call add(r, a:a[i])
      call add(r, a:b[i])
    elseif method == "1"
      call add(r, [a:a[i], a:b[i]])
    else
      call add(r, join([a:a[i], a:b[i]], method))
    endif
    let i+= 1
  endwhile
  if l_a == l_b
    return r
  elseif l_a > l_b
    exe "return r + a:a[" . n . ":]"
  else
    exe "return r + a:b[" . n . ":]"
  endif
endfunction


function! Stack()
  let obj = {}
  let obj.stack = []

  "

  func obj.empty() dict
    return empty(self.stack)
  endfunc

  func obj.size() dict
    return len(self.stack)
  endfunc

  func obj.map(str) dict
    call map(self.stack[-1], a:str)
    return self
  endfunc

  func obj.nmap(cnt, str) dict
    call map(self.stack[(self.size() - a:cnt):-1], a:str)
    return self
  endfunc

  func obj.mapall(str) dict
    call map(self.stack, a:str)
    return self
  endfunc

  func obj.filter(str) dict
    call filter(self.stack, a:str)
    return self
  endfunc

  func obj.sort(...) dict
    if a:0
      call sort(self.stack, a:1)
    else
      call sort(self.stack)
    endif
    return self
  endfunc

  func obj.reverse(...) dict
    let cnt = 1
    if a:0
      let cnt = a:1
    endif
    let x = self.pop(cnt)
    if cnt == 1
      call self.push(reverse(x))
    else
      call self.pusheach(reverse(x))
    endif
    return self
  endfunc

  func obj.range(n, m) dict
    return self.push(range(a:n, a:m))
  endfunc

  func obj.rangeeach(n, m) dict
    return self.pusheach(range(a:n, a:m))
  endfunc

  "---

  func obj.flush() dict
    if self.size() > 0
      call remove(self.stack, 0, -1)
    endif
    return self
  endfunc

  func obj.push(o) dict
    call add(self.stack, a:o)
    return self
  endfunc

  " adds each element in list o separately to the top of the stack
  func obj.pusheach(o) dict
    call extend(self.stack, a:o)
    return self
  endfunc

  func obj.pop(...) dict
    let cnt = 1
    if a:0
      let cnt = a:1
    endif
    if ! self.empty()
      if cnt <= 0
        return self.top()
      elseif cnt == 1
        return remove(self.stack, -1)
      else
        return remove(self.stack, self.size() - cnt, -1)
      endif
    else
      throw "Stack empty!"
    endif
  endfunc

  func obj.top() dict
    if ! self.empty()
      return self.stack[-1]
    else
      return ""
    endif
  endfunc

  " UNCHAINABLE: Returns a copy of the whole stack
  " could do with a better name?
  func obj.s() dict
    return copy(self.stack)
  endfunc

  func obj.string() dict
    return string(self.stack)
  endfunc

  " stack operations

  " NO EXPLICIT TESTS YET:
  func obj.swap() dict
    if self.size() >= 2
      let tmp = self.stack[-1]
      let self.stack[-1] = self.stack[-2]
      let self.stack[-2] = tmp
    endif
    return self
  endfunc

  " NO EXPLICIT TESTS YET:
  func obj.over() dict
    return self.push(self.stack[-2])
  endfunc

  " NO EXPLICIT TESTS YET:
  " takes an optional count
  func obj.dup(...) dict
    let cnt = 1
    if a:0
      let cnt = a:1
    endif
    if cnt == 1
      return self.push(self.top())
    else
      return self.pusheach(repeat([self.top()], a:cnt))
    endif
  endfunc

  " NO EXPLICIT TESTS YET:
  " I need a better name for this - it keeps only the nominated elements on
  " the stack (counting from the top, upwards), dropping all below that
  " number.
  func obj.keep(...) dict
    let cnt = 1
    if a:0
      let cnt = a:1
    endif
    call remove(self.stack, 0, (self.size() - cnt))
    return self
  endfunc

  " numeric stack operations

  func obj.add() dict
    call self.push(self.pop() + self.pop())
    return self
  endfunc

  func obj.sub() dict
    let x = self.pop()
    call self.push(self.pop() - x)
    return self
  endfunc

  func obj.mul() dict
    call self.push(self.pop() * self.pop())
    return self
  endfunc

  func obj.div() dict
    let x = self.pop()
    call self.push(self.pop() / x)
    return self
  endfunc

  func obj.fdiv() dict
    let x = self.pop()
    call self.push((1.0 * self.pop()) / x)
    return self
  endfunc

  func obj.mod() dict
    let x = self.pop()
    call self.push(float2nr(self.pop()) % x)
    return self
  endfunc

  func obj.sum(...) dict
    let cnt = 2
    if a:0
      let cnt = a:1
    endif
    let s = 0
    let c = 0
    while ! self.empty() && (c < cnt)
      let s += str2nr(self.pop())
      let c += 1
    endwhile
    call self.push(s)
    return self
  endfunc

  func obj.sumall() dict
    return self.sum(self.size())
  endfunc

  " string stack operations

  func obj.join(...) dict
    let sep = ''
    if a:0
      let sep = a:1
    endif
    call self.push(join([self.pop(), self.pop()], sep))
    return self
  endfunc

  func obj.njoin(cnt, ...) dict
    let sep = ''
    if a:0
      let sep = a:1
    endif
    let x = self.pop(a:cnt)
    call self.push(join(x, sep))
    return self
  endfunc

  func obj.joinall(...) dict
    return call(self.njoin, [self.size()] + a:000, self)
  endfunc

  func obj.len() dict
    let o = self.pop()
    return self.push(len(o))
  endfunc

  " list stack operations

  " turns cnt elements on top of the stack into a single list element at TOS
  func obj.list(...) dict
    let cnt = self.size()
    if a:0
      let cnt = a:1
    endif
    call self.push(self.pop(cnt))
    return self
  endfunc

  " splits the string at TOS into a list
  func obj.split(...) dict
    let pat = '\s\+'
    if a:0
      let pat = a:1
    endif
    return self.push(split(self.pop(), pat))
  endfunc

  func obj.explode() dict
    return self.pusheach(self.pop())
  endfunc

  " zips the top two elements (both expected to be equal-sized lists) together
  " takes an optional method - see Zip() at top of file for details
  func obj.zip(...) dict
    let method = 0
    if a:0
      let method = a:1
    endif
    let x = self.pop()
    return self.push(Zip(self.pop(), x, method))
  endfunc

  " opt arg 1: method
  " opt arg 2: count of stack elements to bundle into each set
  func obj.zipset(...) dict
    let cnt = self.size() / 2
    let method = 0
    if a:0
      let method = a:1
      if a:0 == 2
        let cnt = a:2
      endif
    endif
    let x = self.pop(cnt)
    return self.push(Zip(self.pop(cnt), x, method))
  endfunc

  " slice list at TOS into cnt slices each as separate lists on the stack
  func obj.slice(...) dict
    let x = deepcopy(self.pop())
    let len = len(x)
    let cnt = len / 2
    if a:0
      let cnt = a:1
    endif
    let newlists = []
    for idx in range(0, len, cnt)
      if idx < len
        if (cnt-1) > len(x)
          let cnt = len(x)
        endif
        call add(newlists, remove(x, 0, (cnt-1)))
      endif
    endfor
    call self.pusheach(newlists)
    return self
  endfunc

  return obj
endfunction

if exists('_S')
  unlet _S
endif
let _S = Stack()
