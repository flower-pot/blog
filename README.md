My blog
=======

Visit at http://flowerpot.io/

Local development
-----------------

If you want to start a blog based on these files you are more than welcome to.

The dependencies are fairly small you only need jekyll and rake.

	gem install jekyll

Just clone the repository and launch it with the following command

	jekyll serve --watch

Then you can view it locally under http://localhost:4000/

Deployment
----------

I use Amazon S3 to host my blog and the `s3_website` gem/cli to push my site to
S3. For this to work you need to install the `s3_website` gem

	gem install s3_website

And then create a config file with the bucket and api key to be able to upload
the files.

License
-------

The contents in `/_posts` are under [Creative Commons
3.0](https://creativecommons.org/licenses/by/3.0/us/) the rest, design, and
structure of this blog is under the MIT License.

The MIT License (MIT)

Copyright (c) 2014 Frederic Branczyk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
