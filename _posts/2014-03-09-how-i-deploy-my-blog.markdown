---
layout: post
title: Deploying blog with GitLab
teaser: How I deploy my blog using post-receive and nginx
commets: true
---

Although I keep my blog on GitHub I also have another copy in my gitlab
instance. To deploy the blog I use the post-receive hook of my repository
in gitlab.

Why I do this? There are a few things that bug me when using GitHub-Pages.
Biggist being that it's not very clear when compilation is done and the new
version is up and running. Now, if I didn't have my server running in 98%
idle most of the time gh-pages would probably suffice.

My post-receive script:

	#!/bin/sh

	GIT_REPO=/home/git/repositories/flower-pot/flowerpot-jekyll.git
	TMP_GIT_CLONE=/home/git/tmp-clones/flowerpot-blog
	PUBLIC_WWW=/var/www/flowerpot.io

	echo Deploy Le Blog
	rm -Rf $PUBLIC_WWW/*
	echo "Clone Git Repo"
	git clone $GIT_REPO $TMP_GIT_CLONE > /dev/null
	echo Build Jekyll Site
	cd $TMP_GIT_CLONE
	jekyll build -s $TMP_GIT_CLONE -d $PUBLIC_WWW
	echo Cleanup
	cd
	rm -Rf $TMP_GIT_CLON

My nginx vhost:

	server {
	  listen   80;
	
	  server_name flowerpot.io www.flowerpot.io;
	
	  root /var/www/flowerpot.io/;
	  index index.html;
	
	  error_page 404 /404.html;
	
	  error_page 500 502 503 504 /50x.html;
	  location = /50x.html {
	    root /usr/share/nginx/www;
	  }
	}

Of course these scripts only work when the gitlab instance and the webserver
are both running on the same machine.

_Even though I like this setup I will be playing around with WebHooks and
see if I find a solution I like better. Anyway I will post my results._
