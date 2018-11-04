#!/usr/bin/env python3
# This Demonstrates a request for user input string

#################################################################################
while True:
    usr_STRING = input('Please write three words: ')
    if usr_STRING == 'exit':
        print('Read "exit" command, exiting ....')
        break
    count_STRING = len(usr_STRING)
    print('There are {} charachters in that string'.format(count_STRING))
print('Done')
