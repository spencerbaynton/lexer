# A simple general-purpose Lexer written in CoffeeScript

A CoffeeScript port of Elijah Rutschman's [A simple general-purpose Lexer written in JavaScript](//elijahr.blogspot.ca/2009/04/lexer-written-in-javascript.html).

I believe there was an error in the `prev` function where it would not return the second last `token`. The culprit appeared to be the extra `arrayPosition--` before the `while` loop. Having changed the `prev` function, I decided to also change the `next` function to match by moving `arrayPosition++` inside the loop. However, prefix incrementation (`++arrayPosition`) was required.