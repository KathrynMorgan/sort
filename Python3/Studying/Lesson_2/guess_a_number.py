#!/usr/bin/env python3
# This is a "guess a number" game.

# Set the Winning Number
_winning = 23

#################################################################################
# While loop to run a prompt-for-number
# - Will give hints if number too high or too low
# - Will set value 'running' to false if guessed correctly & print winner msg
running = True
while running:
    guess = int(input('Enter a number between 0 and 50 : '))
    if guess == _winning:
        print('Congratulations, you picked the winning number!')
        running = False
    elif guess < _winning:
        print('No, that is too low.')
    elif guess > _winning:
        print('No, that is too high.')
    else:
        print('ERROR: cannot continue, exiting!')
print('Done')
