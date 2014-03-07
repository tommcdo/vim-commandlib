"
" Determine the minimum prefix length for a user command to be unambiguous.
"
" Example:
" Suppose the following commands exist:
"     Evimrc, Evimconf, Eplugin
" Calling  commandlib#min_prefix_len('Evimrc')  would return 5;
" Calling  commandlib#min_prefix_len('Eplugin')  would return 2.
"
function! commandlib#min_prefix_len(command)
	for i in range(len(a:command) - 1, 0, -1)
		if exists(':' . strpart(a:command, 0, i)) != 1
			return i + 1
		endif
	endfor
endfunction

"
" Given an array of command names, build a pattern that matches any of them
" including unambiguous prefixes.
"
" Example:
" Suppose the following commands exist:
"     Evimrc, Evimconf, Eplugin, Dvimrc, Dvimconf, Dplugin, Svimrc, Svimconf,
"     Splugin, Split
" Calling
"     commandlib#pattern(['Eplugin', 'Evimconf', 'Evimrc', 'Dplugin', 'Dvimconf', 'Dvimrc', 'Splugin', 'Svimconf', 'Svimrc'])
" would result in the pattern
"     \v<(Ep%[lugin]|Evimc%[onf]|Evimr%[c]|Dp%[lugin]|Dvimc%[onf]|Dvimr%[c]|Splu%[gin]|Svimc%[onf]|Svimr%[c])>
"
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
