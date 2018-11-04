#!/usr/bin/env python3
# TODO
# getopts commandline flag and value passing
# demo classes for variables
#   EG:
#    - city
#    - last name

# Import libraries
import os

#################################################################################
# Define the "hello" function
def print_hello_usr(usr_NAME, friend_NAME):                 # Notice variable names passed through function name brackets
    os.system('clear')
    print('Hello {}, How are you? '.format(friend_NAME))
    print('My name is {}'.format(usr_NAME))

#################################################################################
# Define the "hello" function
def print_hello_world(usr_NAME):
    os.system('clear')
    print('>>  HELLO WERLD!', end=' ')
    print('My name is', usr_NAME, end='  <<   ;)')

#################################################################################
# Ask friend what their name is
def ask_friend_name(friend_NAME):
    os.system('clear')                                      # Clear Terminal
    if friend_NAME is None:                                 # TODO: change to while loop + add sanity check
        friend_NAME = input('Hi Friend; what is your name? : ') # Request user input
        return friend_NAME

#################################################################################
# Ask friend what their name is
def ask_usr_name(usr_NAME):
    os.system('clear')                                      # Clear Terminal
    if usr_NAME is None:                                    # TODO: change to while loop + add sanity check
        usr_NAME = input('First, what is your name? : ')    # Request user input
        return usr_NAME

#################################################################################
# Request user commands
# Options include:
# - hello world
# - hello friend
def req_command(usr_CMD, usr_NAME):

    if usr_CMD is None:                                     # TODO: change to while loop + add sanity check
        usr_CMD = input('What would you like to do {0}? : '.format(usr_NAME))

        if usr_CMD == 'hello world':                        # TODO: change to while loop + add sanity check

            usr_NAME = ask_usr_name(usr_NAME)               # Get User Name
            print_hello_world(usr_NAME)                     # Print Salutations + User Name

        elif usr_CMD == 'hello human':

            usr_NAME = ask_usr_name(usr_NAME)               # Get User Name
            friend_NAME = None
            friend_NAME = ask_friend_name(friend_NAME)      # Get Friend Name

            print_hello_usr(usr_NAME, friend_NAME)          # Print Salutations + User Name

        else:
            print('Sorry, that command was not understood, please try again...')

#################################################################################
# Leading function to define base variables etc.
# Set Default Variables
def main():
    greetings = '''Hello, from here you can do a few things including:
    Send a "hello world message"  [hello world]
    Send a "hello human message"  [hello human]
    '''

    os.system('clear')                                      # Clear Terminal

    # Set Default value of usr_NAME if NOT set at command line
    try:
        usr_NAME
    except NameError:
        usr_NAME = None

    usr_CMD = None                                          # Set Default value of usr_CMD

    print(greetings)
    req_command(usr_CMD, usr_NAME)

#################################################################################
# Start Program
main()
