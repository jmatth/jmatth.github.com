#!/usr/bin/env bash
#Creates reverse tunnel through sauron when online
USER=<Local Username>
REMOTE_USER=<Remote Username>
KEY=/home/you/.ssh/tun_rsa
PORT=<Random High Port>
HOST=<Address of Proxy Server>
export AUTOSSH_GATETIME=0
export AUTOSSH_PORT=27554

#ssh options:
#-f: fork to background
#-N: don't allocate a terminal
#-q: quiet
#-i: path to key file
#-R: reverse tunnel remoteport:host:localport
#-S: control socket location, or none

su -c "autossh -f -N -q -i ${KEY} -R ${PORT}:localhost:22 -S none ${REMOTE_USER}@${HOST} -oControlMaster=no -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no" $USER
