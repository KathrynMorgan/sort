#!/usr/bin/env python3

# Define Variables
age = 29                # Options: [ Authors Age, Real or Fictional ]
gender = "F"            # Options: [ M|F|O ]
author_name = "Kat"     # Options: [ Authors author_name ]
pronoun1 = "she"        # Options: [ she|he|they ]
pronoun2 = "her"        # Options: [ him|her|them ]

# Define line fill charachter & Width + Print Program Header
# Hmmm, look at the format() method's number of arguments?
print('{1:#^80}'.format(author_name, ' Super Cool Demo '))

# Where does this print in the programs output?
# How does this relate to other output strings?
print('{0:#^4}'.format(''), end=' ')

# Print the author_name and age of author
print ('{0} was {1} years old when {2} wrote this code.'.format(author_name, age, pronoun1))

# Show that the .format method substitutes each argument value with or without
# numbering
print ('Also see that {} can write {} code without numbers for "format()"'.format(author_name, pronoun2))

# lookey lookey, a keyword-based .format method
# Notice printable quotation marks around 'book_name' string
# Notice that 'author_name' is set differently for this line
print ('{author_name} wrote a small python script named {book_name}'.format(author_name='Kathryn', book_name='"A Little Python"'))

# Tie strings together
print('Sometimes she', end=' ')
print('({})'.format(author_name), end='')
print(' experiments for fun!' )

# Define new lines
# How does the apostrophe in [ can't ] print to screen without messing up the
#   interpreter?
print('Are you ready? Count with me! \n1\n2\n3\nSo much fun can\'t you see!')

# Where does this line go?
r"Yep, thats right, new lines are indicated by \n"

# What happens with line breaks in code like this? What happens with spacing?
print('Tell me the alphabet! \n \
      Please please please? \
      What are the first 3? \nc, a, b!')

# Now what happens, can you tell what will happen to these two separate lines?
# What happens with spacing too?
print('\
Can you keep up?\
Keep up with me?\
')

# Print question
# Notice that 'author_name' still matches the top of file value
print ('Why is {} playing with that python code?'.format(author_name))




