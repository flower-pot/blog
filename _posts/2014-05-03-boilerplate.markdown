---
layout: post
title: Boilerplates
teaser: What I learned developing a boilerplate
commets: true
---

I admit it, I wrote a boilerplate. It started with two projects I am working on
that had the same basic requirements:

* Ruby on Rails
* AngularJS
* Token Authentication for an API
* Role System
* Configurable

So I started developing them on the same base. The goal was to have a base that
could be updated if a bug comes up and it could be fixed for both applications
at once. Plus I wasn't able to find a very good boilerplate for Rails and
AngularJS, so I thought I could also give back by putting it on GitHub.

The result is a Boilerplate that is not being used. Even though the projects
that led me to develop this boilerplate use similar technologies there is a key
difference that drove the projects apart. Besides from myself, they are being
developed by different people.

With different people working on two different projects it is inevitable that
the projects push in contrasting directions, thus changing things in the
projects that they used to have in common. Then we decided to drop AngularJS in
one of the projects making them not so similar anymore. In the beginning I
tried to merge changes that affected both applications, but soon gave that up
as they drifted too far apart. The only similarity the projects now share is
that they use the SettingsLogic gem to manage the applications' configurations.
And the base-app in some parts a mess, because I tried to get both apps in one.

Although it did not turn out to have worked well, in my opinion this was a
mistake I had to make. If you want to take a look at it anyways go ahead, it is
not as well tested as advertised on the frontpage.

{% render_github_repo flower-pot/base-app %}

On the bright side, it taught me about best practises. I learned to use code
metrics, ci and improved the way I write tests. So the downside is a not so
well tested base application, but an improvement in methods.

Maybe you can drop a comment about your experience with boilerplates.

Cheers
