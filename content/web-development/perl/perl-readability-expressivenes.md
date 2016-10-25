---
ID: 37  
Itemtype: Item/Page/Article
Title: "Perl: Readability, Expressiveness, and Concision"
Slug: perl-readability-expressivenes  
GUID: tag:www.webquills.net,2008:/scroll//4.37  
disqus_url: http://www.webquills.net/scroll/2008/07/perl-readability-expressivenes.html
Created: 2008-07-07 07:09:43  
Updated: 2008-07-07 07:48:34  
Published: 2008-07-07 07:05:06     
...

# Perl: Readability, Expressiveness, and Concision
<blockquote class="thesis"><p>Writing readable code means expressing yourself 
as clearly and correctly as you can, not targeting the lowest common 
denominator of reader.</p></blockquote>

There are *many* people out there who are [preaching the gospel of readable code][1]. I myself am one of them. I am a strong proponent of expressive variable and subroutine names, for example. Unless you are a fire-and-forget contract programmer, you are going to be reading your code a lot more often than you write it. But honestly, if code readability is your primary concern, use Python, not Perl.

Reading good Python code is like reading a novel by Dan Brown or Michael Crichton. The language is clean and simple, allowing you to move forward easily, and quickly grasp the point of the story. The vocabulary is easily attainable and won't stretch your brain too far. I *like* reading Python code. It's an easy read &mdash; a beach read.

Reading good Perl code is like reading Shakespeare. Every line is deeply expressive, both in its content and its rhythm. You probably need a dictionary to look up some words that, while not perhaps in everyday usage, express *exactly* what the author intended. It's still English, but you have to work a little harder at reading it, because it's beautiful, powerful English. 

When I write code, I *am* concerned about readability. But I am also concerned about *expressiveness* and *concision*. I have something I am trying to say. I don't always want two paragraphs of easy prose that approximate my point. Most of the time I want *le mot juste*, just the right word, a precise expression of exactly what I mean that requires no further elaboration. 

Now, I don't intend to imply that my Perl is of a class with Shakespeare's verse (nor Flaubert's prose). What I am saying is that some stories cannot be told in terms of Dick and Jane and Spot. Complex problems often require complex language to describe their solutions. I love writing such solutions in Perl, because Perl, like English, offers me a broad and rich vocabulary of idiom I can use to construct complex works easily. 

Those who speak pidgin-Perl can usually puzzle out what the code is doing, but they are going to get hung up at some points, and they are going to miss a lot of detail. That is not a flaw in the language, nor an error on the part of the writer. It is simply the nature of the form. But those who understand the depth of the language can truly appreciate the subtlety of a nice, tight hack. 

The key to writing code that is both readable and expressive is to build a bridge with your comments that help the unfamiliar reader find his way through the complex and obscure portions. If you find yourself using a rare or arcane idiom because its the *right* thing to do, don't dumb it down into fifty lines of loops for novice programmers. Instead, write a full paragraph of explanation above your one-line hack. Include references to man pages, books, and web sites. Scholarly works always have footnotes. The reader will not only gain a better understanding of your code, but perhaps learn a new technique that improves his own.

Writing readable code does not mean writing for the lowest common denominator of reader. It means expressing your point as clearly and correctly as you can. Try to make your code readable, but don't sacrifice concision for readability. You should expect more from your reader, rather than expecting less from your code.

P.S. For another view on the subject, you can read about the [Unobfuscated Perl Code Contest][2].

[1]: http://use.perl.org/~Phred/journal/36799
[2]: http://humorix.org/articles/2000/09/unobfuscated/




