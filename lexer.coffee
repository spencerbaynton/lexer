definitions =
	identifier:        { regexp: /^[a-zA-Z]+[a-zA-Z0-9]*$/, skip: false },
	string:            { regexp: /^\"[^\"]*\"|\'[^\']*\'$/, skip: false },
	decimal_integer:   { regexp: /^[1-9]*\d+$/,             skip: false },
	left_parenthesis:  { regexp: /^\($/,                    skip: false },
	right_parenthesis: { regexp: /^\)$/,                    skip: false },
	comma:             { regexp: /^,$/,                     skip: false },
	whitespace:        { regexp: /^[\t \n]$/,               skip: true  }

class Lexer

	index = 0
	length = 1
	arrayPosition = -1

	tokens: []
	lexemes: []
	token: null
	lexeme: null
	bof: true
	eof: false
	line_number: 0
	char_position: 0

	constructor: (@string) ->

		while index + length <= @string.length

			small = @string.substr(index, length)
			big = @string.substr(index, length + 1)

			for def of definitions

				smallmatch = small.match(definitions[def].regexp) isnt null
				bigmatch = big.match(definitions[def].regexp) isnt null

				if smallmatch and (not bigmatch or small is big)

					index += length
					length = 0

					@tokens.push def
					@lexemes.push small

					break

			length++

	next: (@count = 1) ->

		while @count-- > 0

			if ++arrayPosition < @tokens.length

				@token = @tokens[arrayPosition]
				@lexeme = @lexemes[arrayPosition]
				@bof = false
				@char_position += @lexeme.length

				if definitions[@token].skip

					if @token is 'newline'

						@line_number++
						@char_position = 0

					@next()
				
			else
				
				@token = 'EOF'
				@lexeme = null
				@eof = true

	prev: (@count = 1) ->

		while @count-- > 0
			
			if arrayPosition-- > 0

				@token = @tokens[arrayPosition]
				@lexeme = @lexemes[arrayPosition]
				@eof = false
				@char_position -= @lexeme.length

				if definitions[@token].skip
		
					if @token is 'newline'

						@line_number--
						@char_position = 0
		
					@prev()

			else

				@token = 'BOF'
				@lexeme = null
				@bof = true

				break

lexer = new Lexer("hello('world', 2)")

while not lexer.eof

	lexer.next()
	console.log lexer.token

while not lexer.bof

	lexer.prev()
	console.log lexer.token