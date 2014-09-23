#!/bin/bash

sudo apt-get install python-software-properties
sudo add-apt-repository ppa:saltstack/salt
sudo apt-get update

sudo apt-get install -q -y salt-master
sudo apt-get install -q -y salt-minion

su -l root -c "sed -i 's/#master: salt/master: 10.0.2.2/' /etc/salt/minion"

service salt-minion restart
