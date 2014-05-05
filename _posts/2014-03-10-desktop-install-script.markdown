---
layout: post
title: Desktop install script
teaser: A bash script I use to install my Ubuntu machines
commets: true
---

I like to have a clean machine and install it fresh every time there is a new
Ubuntu release. However, I also want to keep my cool configurations so that's
why I have [my dotfiles on GitHub](github.com/flower-pot/desktop-install).

In the past when people asked me how I got my shell to look like that, or how
they should install rails, what dependencies they need I would either tell them
to look at my dotfiles or point them to an article describing how to install it.

A lot of my colleagues have lately been getting into rails and linux overall. So
their interest in my dotfiles has also increased. Problem is I spend a lot of
time explaining what to do to get their installation to be like mine. So I 
decided to write a script which does all of that and in case someone is
interested in what the script actually does they can just look at the code.

{% render_github_repo flower-pot/desktop-install %}

It is capable of installing

- Essential stuff ( curl, git, build-essentials, vpn, firefox, etc )
- Rails via rvm
- Ansible provisioning software
- Vagrant
- Zsh, vim, and my dotfiles
- fixubuntu
- the heroku toolbelt
- nodejs, npm and karma

When running the script the user selects what to install. (by default everything)

_Lately I have been testing it pretty intensively to be sure that it works when
upgrading to ubuntu 14.04._

Hope this can help you!

Cheers
