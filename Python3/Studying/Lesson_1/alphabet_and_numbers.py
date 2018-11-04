#!/usr/bin/env python3

# Make a variable into a multi line string; where does this variable get used?
first = ''' Tell me the alphabet!
 Please please please?
 What are the first 4?
'''
second = '''
 But wait, that looks funny!\n\
 Can we put them in order?\n\
'''

# We are going to count and play with the alphabet!
print(first, '\n      c, a, b, d!')

# Can we do better?
print(second)

# Set your base number & echo the value to screen
# What happens here when you use the semicolon?
# What commentary can you provide on this syntax?
c = 1; print('The starting count is:',c)

# Now lets keep count and say them in order
# Whats the difference between the first, second, and third counter sum syntax?
# Do all syntax(es) work?
print(c,'= a')
c = c + 1
print(c,'= b')
c = \
c + 1
print(c,'= c')
c = \
    c + 1
print(c, '= d')
# Remove the "#" from the last line (do not remove the leading space)
# Try to run the program, what happens?
# Repeat the 4th count!
# print(c, '= d')
