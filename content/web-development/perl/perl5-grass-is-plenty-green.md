ID: 12  
Itemtype: Item/Page/Article
Title: Perl 5: The grass is plenty green  
Slug: perl5-grass-is-plenty-green
GUID: tag:www.webquills.net,2007:/scroll//1.1  
Created: 2007-12-15 16:43:19
Updated: 2007-12-22 10:36:32
Published: 2007-12-22 10:33:19   
Tags: framework perl webdev webdesign


# Perl 5: The grass is plenty green
A few months ago I wrote a missive lamenting the coolness going on in other languages in terms of web frameworks and the dearth of magical leaps forward in Perl. Well, I take it all back. Serves me right for not recognizing hype for what it is.

Each of the frameworks from other languages that I examined promised great leaps in productivity for programmers of that language. But what I came to realize was that these were improvements that I had *already* experienced in Perl. The streamlining did not come from the *language* at all. One scripting language, it seems, is pretty much as good as the next when it comes to productivity for the skilled programmer. No, the great leap forward came from applying a well organized web application development framework and its associated tools to the problem of web development, where before there had been no organized solution and only a rudimentary tool set.

But I have been using Perl web application frameworks for years. (I use the plural of framework because <abbr title="There Is More Than One Way To Do It">TIMTOWTDI</abbr> in Perl.) [Apache+mod\_perl](http://perl.apache.org) is an amazingly rich web application framework on its own. Perl was (I believe) the first scripting language to be embedded in the web server itself, and is still the best option for manipulating the rich, complex internals of Apache. [HTML::Mason](http://www.masonhq.com)'s ApacheHandler is a simple layer on top of mod\_perl that is a highly effective solution to certain classes of problems. Richer, more modern frameworks like [Catalyst][] and [Jifty][] do more for you, but also require you to do more learning to get productive. In Perl, we're spoiled for choice, which is a problem all its own. But the point is, the other scripting languages haven't beat Perl in the web framework race. They are just now catching up!

[Catalyst]: http://catalyst.perl.org
[Jifty]: http://jifty.org

This is certainly not a call for Rails developers to switch to Perl. Why should they? The fact of the matter is that web frameworks in whatever language are substantially similar to one another, because they are each a solution to the exact same problem, built under similar constraints.

Programmers should use whatever language fits their mind best, because that is where they will find themselves most productive. For some people, that's Java. (Some people are *weird*.) For some its Python or Ruby. More power to you. But if you are productive in Perl, don't be lured away to some other language by the greener-looking grass on their side of the fence.The grass is plenty green right here.

