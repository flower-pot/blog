---
layout: post
title: Securing a Server
archived: true
---

> Hint: Tested on Debian 6 and 7, but should also work on Ubuntu server

## First steps

### Install updates

Make sure our system is up to date.

    apt-get update
    apt-get upgrade

### This and that

First we'll create a symlink from /bin/sh to /bin/bash

    dpkg-reconfigure dash

And select no.

### Hostname

We will set the hostname of our system.

    vim /etc/hosts

Have your first two lines look like this.

    127.0.0.1 localhost.localdomain localhost
    192.168.0.100 server1.domain.tld server1

Then also add it to the file /etc/filename then start hostname.sh

    echo server1.domain.tld > /etc/hostname
    /etc/init.d/hostname.sh start

After that the output of these should be the same

    hostname
    hostname -f

### ntp system clock

To synchronize our system clock via ntp we only have to install ntp and ntpdate

    apt-get install ntp ntpdate

## Securing your system

### Change root password

Change the root password to something long and complex.

    passwd

### Fail2ban

Fail2ban watches logins and blocks suspicious connections. We won't need to configure anything it's awesome out of the box.

    apt-get install fail2ban

### Creating the login user

Now we will create the user we are going to use to login to our system.

    useradd flowerpot
    mkdir /home/flowerpot
    mkdir /home/flowerpot/.ssh
    chmod 700 /home/flowerpot/.ssh

And set a long complicated password.

    passwd flowerpot

Grant the new users all sudo permissions.

    visudo

And add the line

    flowerpot ALL=(ALL) ALL

#### Public key authentication

Add the public keys you want to grant access to the system.

    vim /home/flowerpot/.ssh/authorized_keys

    chmod 400 /home/flowerpot/.ssh/authorized_keys
    chown flowerpot:flowerpot /home/flowerpot -R

### Lock SSH

Turn off root login and only allow key authentication.

    vim /etc/ssh/sshd_config

Change the following lines to disable root login and enable only key authentication.

    PermitRootLogin no
    PasswordAuthentication no

And now to refresh the configuration we made we need to restart the ssh service.

    service ssh restart

### Notification on login

I like to know when someone connects via ssh to my server so I create a little script that sends me the information I want. I put it in /root/scripts/shell-login.sh

    #!/bin/bash
    echo "Login auf $(hostname) am $(date +%Y-%m-%d) um $(date +%H:%M)"
    echo "Benutzer: $USER"
    echo
    finger

Now to run the script when a user is logging in put

    /root/scripts/shell-login.sh | mailx -s "SSH Login auf IHR-HOSTNAME" user@domain.tld ```

in

    /etc/profile

Then the scripts needs to be executable

    chmod 755 /root/scripts/shell-login.sh

### Get an E-Mail when there is a new security update

There's a package that tells you when there is a new security update available.

    apt-get install apticron

Then add your E-Mail in

    /etc/apticron/apticron.conf

### Monit

To make sure your services are always running you can use monit.

    apt-get install monit

Then make a little change to the config to make monit run as a service

    startup = 1

Then we will have to add every service we want to monitor to the monit config.

    vim /etc/monit/monitrc

An example config for CPU load, ssh and MySQL monitoring.

    set daemon 180
    set logfile syslog facility log_daemon
    set mailserver localhost
    set mail-format { from: user@domain.tld }
    set alert user@domain.tld
 
    check system localhost
         if loadavg (5min) > 1 then alert
         if memory usage > 75% then alert
         if cpu usage (user) > 70% then alert
         if cpu usage (system) > 30% then alert
         if cpu usage (wait) > 20% then alert

    check process sshd with pidfile /var/run/sshd.pid
         start program    "/etc/init.d/ssh start"
         stop program    "/etc/init.d/ssh stop"
         if failed port 22 protocol ssh then restart
         if 5 restarts within 5 cycles then timeout
 
    check process mysql with pidfile /var/run/mysqld/mysqld.pid database
         start program = "/etc/init.d/mysql start"
         stop program = "/etc/init.d/mysql stop"
         if failed host 127.0.0.1 port 3306 then restart
         if 5 restarts within 5 cycles then timeout

These are just examples, if you need more you will most certainly find it on the internet.

### iptables

iptables will be my firewall. Let's go ahead and create a new iptables file

    vim /etc/iptables.test.rules

Now we are going to add some rules

    *filter

    -A INPUT -i lo -j ACCEPT
    -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

    -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    -A OUTPUT -j ACCEPT

    -A INPUT -p tcp --dport 80 -j ACCEPT
    -A INPUT -p tcp --dport 443 -j ACCEPT

    -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

    -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

    -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

    -A INPUT -j REJECT
    -A FORWARD -j REJECT

    COMMIT

Then we activate these rules

    iptables-restore < /etc/iptables.test.rules

Then we can check and see the difference

    iptables -L

Add all the ports you need to this and when you are done save like this.

    iptables-save > /etc/iptables.up.rules

And to make sure it that it will work after a reboot we create a new file.

    vim /etc/network/if-pre-up.d/iptables

And add these lines to it

    #!/bin/bash
    /sbin/iptables-restore < /etc/iptables.up.rules

Then make it executable

    chmod +x /etc/network/if-pre-up.d/iptables

### That's it

*If I have some spare time and anyone wants me to, I might make a puppet or
ansible cookbook for this*
