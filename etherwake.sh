#!/bin/bash

# definition of MAC addresses
carl=fc:15:b4:fd:d4:52

echo "Which PC to wake?"
echo "c) Carl's Laptop"
echo "q) quit"
read input1
case $input1 in
    c)
    /usr/bin/wol $carl
    ;;
    # g)
    # uses wol over the internet provided that port 9 is
    # forwarded to ghost on ghost's router
    #    /usr/bin/wol --port=9 --host=ghost.mydomain.org
    #    $ghost
    #    ;;
    q)
    break
    ;;
esac
