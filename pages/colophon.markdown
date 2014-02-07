---
title: Colophon
---

The original source of this blog was authored using Sublime Text[^1] in HTML and Markdown[^2].  

The source is rendered into HTML using the blogging software Hakyll[^3].  Custom templates for the blog are written in HTML, CSS and JavaScript and are heavily (read _"completely"_) based on an open-source design by Danny Su.[^4][^5]

The weblog is deployed on an Amazon EC2 Ubuntu instance.

[^1]: http://www.sublimetext.com  This is my go-to text editor.  I've written and maintained a half-dozen complex web services with Sublime Text.  While it's not the most Mac-like application, it's fast and well-built.  For the purposes of this blog, it also handles Markdown quite nicely.
[^2]: https://daringfireball.net/projects/markdown/ Markdown is the _lingua franca_ of technical writing.  It allows you to write the text of a document using a minimal and readable markup.  Authoring the marked-up document inline means that the writer never takes his hand off the keyboard.  (Think of the steps you must go through to write a marked up document in a typical word processor.)
[^3]: http://jaspervdj.be/hakyll/  Hakyll is a static site generator library written in Haskell that allows blog authors to write their content and compile it into a static blog.  A static blog is a great way to publish because they render quickly on the reader's side, they are very easy to deploy on whatever server you like, and all of the content is under version control just like source code.
[^4]: http://www.dannysu.com
[^5]: https://github.com/dannysu/hakyll-blog  The source code on github.