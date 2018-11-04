#!/bin/bash

if [[ x${1} == "x" ]] ; then
  echo "Need to specify container name"
  exit 127
else
  C_NAME=${1}
fi
lxc init ubuntu:x ${C_NAME}
lxc config set ${C_NAME} raw.idmap "both $UID 1000"
lxc config device add ${C_NAME} X0 disk path=/tmp/.X11-unix/X0 source=/tmp/.X11-unix/X0
lxc config device add ${C_NAME} Xauthority disk path=/home/ubuntu/.Xauthority source=/home/${USER}/.Xauthority
lxc config device add ${C_NAME} gpu gpu 
lxc config device set ${C_NAME} gpu uid 1000
lxc config device set ${C_NAME} gpu gid 1000
lxc start ${C_NAME}
echo "*****"
echo "** Waiting 5 seconds for container to start"
echo "*****"
sleep 5
lxc exec ${C_NAME} -- apt update
lxc exec ${C_NAME} -- apt upgrade -y
lxc exec ${C_NAME} -- apt install -y x11-apps mesa-utils nvidia-375
lxc exec ${C_NAME} -- cp /etc/skel/.* /home/ubuntu
lxc exec ${C_NAME} -- chown -R ubuntu: /home/ubuntu
echo "*****"
echo "** Ignore errors here"
echo "*****"

echo "*****"
echo "** Restarting container"
echo "*****"

lxc restart ${C_NAME}

echo "*****"
echo "** Run the following commands:"
echo "** lxc exec ${C_NAME} -- sudo --login --user ubuntu"
echo "** $ echo \"export DISPLAY=:0\" >> ~/.profile"
echo "*****"
