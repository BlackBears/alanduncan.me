---
layout: post
title: Anchors in Markdown
date: 2013-03-25 05:45
comments: false
categories: [markdown, octopress, til]
tags: Blogging
---
TIL how to use anchors in [Markdown](http://daringfireball.net/projects/markdown/) documents.  I needed to use this in a long blog post in my [Octopress](http://octopress.org) blog and was stymied.

As usual, I found the [answer](http://stackoverflow.com/questions/5319754/cross-reference-named-anchor-in-markdown/7335259#7335259) on Stack Overflow.

``` html
Beam me [up](#enterprise), Scotty

<a id="enterprise"></a>
```

It's a great way to move around in longer content.