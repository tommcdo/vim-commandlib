" Determine the minimum prefix length for a user command to be unambiguous.
" For example, if there a command named Fishhat, the minimum prefix length for
" another command named Finisher would be 3.
function! commandlib#min_prefix_len(command)
	for i in range(len(a:command) - 1, 0, -1)
		if exists(':' . strpart(a:command, 0, i)) != 1
			return i + 1
		endif
	endfor
endfunction

" Given an array of command names, build a pattern that matches any of them
" inclluding unambiguous prefixes.
function! commandlib#pattern(commands)
	let alternation = ''
	for command in a:commands
		let len = commandlib#min_prefix_len(command)
		if len == len(command)
			let alternation .= command . '|'
		else
			let alternation .= strpart(command, 0, len) . '%[' . strpart(command, len) . ']|'
		endif
	endfor
	let alternation = alternation[:-2]
	return '\v<(' . alternation . ')>'
endfunction
