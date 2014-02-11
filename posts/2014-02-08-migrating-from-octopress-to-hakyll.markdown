---
layout: post
title: Migrating from Octopress to Hakyll
date: 2014-02-08 23:03:00
comments: false
categories: [blogging]
tags: Blogging, Programming 
---

After blogging on Octopress for a couple years, I got tired of its "heaviness."  Octopress has been a great way to blog; and deployment to Amazon S3 couldn't be easier.  But after playing around with the styling a  bit, I still felt like trying to radically change and simplify the design required too much dealing with the internals.  In short, I was looking for a static blogging system that offered more simplicity and flexibility than Octopress.  That's how I wandered into Hakyll.

At its core, Hakyll is a Haskell library on which bloggers can build a system for generating static sites.  Because at its core, Hakyll is just a library, it means that the blogger can develop his own systm for parsing posts, generating pages, linking the blog together, and even deploying.  I admit that I know nothing about Haskell; but it looks interesting.  And I like the way Hakyll works; so I'm willing to give it a try.

##Installation##

####Installing Haskell on OS X 10.9####

I chose to install haskell-platform using homebrew[^1], simply as:

```bash
$ brew search haskell
haskell-platform

$ brew install haskell-platform
```

There were a handful of issues involving the Xcode command line tools and the PATH variable; but none were difficult.  And I failed to record what they were.  Sorry.

####Installing Hakyll####

Install Hakyll using cabal[^2] as:

```bash
$ cabal install hakyll
```

One of the things that the cabal package for hakyll gives you is an executable called `hakyll-init` that when run, creates an example site.  Ideally, you should just be able to:

```bash
$ hakyll-init my-great-site
```

but for me, `hakyll-init` is not found.  You'll have to make sure that `~/.cabal/bin` is in you PATH for that to work.

####Configuring the example site####

Once you've built a sample site with `hakyll-init` you need to use the use ghc to build the site configuration program `site.hs`:

```bash
$ cd my-site
$ ghc --make site.hs
$ ./site build
```

Now you can preview your site with `./site watch` on localhost:8000.

####Deployment####

<img src="/images/transmit-fav.png" style="float: left; padding-right: 10px;"> My site is hosted on Amazon S3 and I use Transmit to synchronize my local directory with the bucket that serves the site.  This works well, except for the fact that CSS is poorly handled by Amazon web services when you serve a static site from an S3 bucket.  The problem is the Content-Type of the css files is provided as `binary/octet-stream`.  This is not right.  You can change in the management console; but it gets reset every time you upload the file.  Clearly not a good solution.

If you use Transmit, though, you can set the Content-Type for cloud uploads on a per-file extension basis.  The relevant details are described in a [blog post](http://www.adamwilcox.org/2012/05/04/css-on-amazon-s3/) by Adam Wilcox.  Basically, you just go Transmit preferences, Cloud tab, and set the Custom S3 Upload Headers for css files:

| Header name         |  Value             |
|---------------------|--------------------|
| Content-Type        | text/css           |
| x-amz-storage-class | REDUCED_REDUNDANCY |

After making those changes, static blogs hosted on S3 will return css files with the correct type header.

Since Transmit is scriptable, you can write an Applescript to connect to your S3 bucket and sync.  The most straightforward way to make this work is to create favorite in Transmit as show in the screenshot.  If you use a named favorite that specifies both the remote and local paths, you should be able to adapt the following script to perform the sync.

<script src="https://gist.github.com/cocoa-factory/1a910c7ffd203173ae0e.js"></script>

Finally, you'll want to link that script into the deploy command in your blog configuration.  There you'll want to modify your `site.hs` file and recompile it.

```haskell
config :: Configuration
config = defaultConfiguration
        {   deployCommand = "osascript /Users/alan/Documents/dev/scripts+tools/applescript/scripts/active/sync-blog-s3.scpt" }
```

Now from the command line, I can just:

```bash
$ ./site deploy
```

to execute my deployment Applescript.

####Post migration####
Your post source is written in Markdown; so you'll probably want to write rules into your `site.hs` file that specify how you want to parse the metadata in those files.  If I knew more Haskell, I'd describe that in more detail for you.  I had a small number of posts to migrate; so I changed the metadata format manually.  Essentially I changed the formatting of the tags (they're called _categories_ in Octopress) and removed quote marks from the post titles.


[^1]: [Homebrew](http://brew.sh) is a package manager for OS X.
[^2]: [Cabal](http://www.haskell.org/cabal/) is a build and package system for Haskell.