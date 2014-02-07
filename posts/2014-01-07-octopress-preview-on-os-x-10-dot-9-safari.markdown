---
layout: post
title: Octopress preview on OS X 10.9 Safari
date: 2014-01-07 01:28:20 -0600
comments: false
categories: [octopress]
tags: Blogging, Octopress, Hakyll
---
Safari on OS X 10.9 Mavericks breaks the ability to use WEBrick to preview your Octopress blog.  Max Melzer has the fix[^1] and it works.

Basically you just need to switch to using `thin` as the local server.

``` bash
cd your/octopress/root/directory/
echo gem \"thin\" >> Gemfile
```

and

``` bash
bundle install
```

[^1]: http://www.moehrenzahn.de/switching-to-thin