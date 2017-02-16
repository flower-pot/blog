---
layout: post
title: Jekyll + Disqus
---

In my previous post I've been asked to share my Disqus setup with Jekyll. It is
fairly simple, but I wanted to share it with everyone.

First you have to sign up for Disqus and add a Website. Then you are told to
integrate some javascript and html on your website. The way I do it is with
this snipped:

```html
{% highlight html %}
{% if page.commets %}
  <div class="hidden-print">
    <hr />
    <div id="disqus_thread"></div>
    <script type="text/javascript">
      /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
      var disqus_shortname = 'flowerpot-dev'; // required: replace example with your forum shortname
      {% assign disqus_identifier = '{{ page.url }}' %}
      var disqus_identifier = '{{ disqus_identifier }}';
      {% assign disqus_title = '{{ page.title }}' %}
      var disqus_title = '{{ disqus_title }}';
      {% assign disqus_url = '{{ site.url }}{{ page.url }}' %}
      var disqus_url = '{{ disqus_url }}';
      /* * * DON'T EDIT BELOW THIS LINE * * */
      (function() {
         var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
         dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
         (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
       })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
  </div>
{% endif %}
{% endhighlight %}
```

I have that little If-Statement around the block, so I can decide to turn off
comments if I want to. I would do so by typing `comments: false` in the
variables of a post.

You will obviously have to replace `disqus_shortname` with yours for it to
work.

If you have any other questions let me know and I will go into detail where
needed.

Cheers and excuse me for no code highligthing, I will fix it as soon as
possible!
