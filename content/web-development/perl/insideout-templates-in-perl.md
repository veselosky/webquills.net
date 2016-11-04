---
ID: 31  
Itemtype: Item/Page/Article
Title: Inside-out Templates in Perl  
Slug: insideout-templates-in-perl  
GUID: tag:www.webquills.net,2008:/scroll//1.21  
Published: 2008-02-09 07:57:44     
Tags: [Templates,]
...

# Inside-out Templates in Perl
Pop quiz, hotshot. Your team has undertaken a project to completely redesign your web site. Fancy-pants designers are hard at work generating not one but *three* new designs. The designs will be put through a battery of usability tests, after which the best parts will be combined into the final design. They need *you* to create server-side logic that will populate content areas, navigation, and various design elements according to how the user manipulates the site. But the HTML is nowhere near finished, and the designers will be tweaking it right up to the day of the test. *What do you do?*

Your normal workflow is shot. Typically you receive finished HTML from the designers, break it down into reusable components, add template tags to represent program objects and logic, and prepare the whole thing to be run through a template processor to generate output. That's out. Any attempt to mess with their HTML will be counter-productive. The priority here is to perfect the design for usability testing, and that means rapid iteration in visual design tools. Template tags will get in the way.

The time crunch is serious. They need a *functional* prototype to test with, but you can't embed the functionality into the template. They're holding your templates hostage.

My solution: Shoot the hostage.


## Binding logic to document structure

The key to solving a seemingly impossible problem is not to come up with a seemingly impossible solution. It is to reframe the problem into something that's easier to solve.

In this situation, the problems *seems* to be that I have to embed my template logic into these HTML files at the last minute, with no hope of having time for testing. Since this is nearly impossible, let's break down the problem. What is the template logic going to actually do? 

1. Extract content from a database, keyed by the requested URL, and wrap it in one of the provided designs.
2. Rewrite the navigation section according to the URL of the current page.
3. Perform several variable substitutions based on the site being tested.

None of these things are really dependent on the particular HTML design they are going into. They are just inserting or changing some content at a particular position in the document structure. I can write this logic without having the HTML. The trouble is, the logic does not do anything until it is bound to the document structure in some way. Template systems perform this binding by *embedding* the logic into the structure itself. Since I can't put template markers into the HTML, what I need is a way to bind the logic to the document structure *from the outside*.

Being a Perl hacker, my first thought was, can I rewrite the content using a regular expression string substitution? Having a look at the HTML in progress, I quickly decided this was an unreliable method. If they changed the order of tags or attributes, which they were sure to do, everything would break, and I would be up all night debugging regular expressions. Not my idea of a party.

If only this were a client-side application, I found myself thinking. Then I could use [jQuery][] or another javascript toolkit to rewrite the <abbr title="Document Object Model">DOM</abbr> at the client. In old-school javascript, this wouldn't be much better, but modern techniques like [Hijax][] allow you to separate the code from the structure to manipulate the DOM from the outside.

Hang on a minute. At the server, I have access to everything the client has and then some. Can't I build a DOM at the server and manipulate it in Perl?

[jQuery]: http://jquery.com/
[Hijax]: http://domscripting.com/blog/display/41

## An inside-out template using HTML::TreeBuilder

Off to [CPAN Search][CPAN], and in minutes I was writing my first experimental script with [HTML::TreeBuilder][]. I started with something like this:

	:::perl
	#!/usr/bin/perl
	use HTML::TreeBuilder;

	my $tree = HTML::TreeBuilder->new();
	$tree->parse_file('wrapper.html');

	my @links = $tree->look_down( _tag => 'a');

	printf 'Found %s links', scalar(@links);
	print "\n";
	for (@links) {
	        print $_->attr('href'),"\n";
	}

Sure enough, I was able to print out all the linked URLs just like that! 

My next step was not code, but social engineering. I talked to our designers and established that all the HTML designs would use the same HTML id attributes for the same document elements, and that these id attributes would not change. I needed this structural stability for my code to work. Fortunately, our clever designers were already on the ball and didn't have to change a thing.

I quickly implemented some procedural code that would perform the replacements I was after. Most of the code was spent loading the strings and structures that would serve as replacement text, so it isn't really useful to display here. But here are a few tips that might help you out if you decide to use HTML::TreeBuilder in your application.

### TreeBulder Tip 1: Comments are stripped by default
The designers needed to see their "trace" comments in the output of the processed template. HTML::TreeBuilder throws comments away by default. To keep them:
	
	:::perl
	my $tree = HTML::TreeBuilder->new();
	$tree->store_comments(1); # Before parsing!

This makes comments appear as separate nodes in the tree, with a tag of `~comment`. You can also preserve PHP code and other processing instructions using `$tree->store_pis(1)`, and preserve the DOCTYPE declaration with `$tree->store_declarations(1)`, although I didn't need to.

### TreeBuilder Tip 2: Enable parsing XML-style empty element tags
My designers were using tools that produced (for the most part) valid XHTML. In XHTML, the empty tag syntax is used for tags like `link` and `img`.

    :::XML
    <link rel="stylesheet" href="/global.css" />
    			<!-- XHTML Empty tag syntax  ^^^ -->

TreeBuilder's default parse mode (inherited from HTML::Parser) treats these trailing slashes as character data. This didn't cause any actual problems for me, but better safe than sorry. I explicitly enabled support for empty tags this way:

	:::perl
	$tree->empty_element_tags(1); # Before parsing!

### TreeBuilder Tip 3: Be explicit with `as_HTML()`
To turn the in-memory model back into HTML text for output, you use the `as_HTML()` method. This method can be called with no arguments, in which case it implements some default behaviors which are almost certainly not what your designers want.

The first argument describes what character entities should be HTML encoded in PCDATA (i.e. text nodes). By default, it encodes everything that [HTML::Entities][] knows how to encode. This is probably overkill. The docs say that you can be compatible with previous versions by passing '<>&'.

The second argument is the "indent string". By default this is undefined, which is nice for production since it eliminates unnecessary white space in the output. But when you are debugging the output, it's nice to have it "pretty printed". So I specified a four-space indent. With this setting, TreeBuilder neatly aligns open and close tags, making debugging much easier.

The third and most important argument defines elements whose end-tags are "optional", and by optional it means *omitted*. If you want your HTML to validate, and more importantly not be *broken*, you need to pass an empty hash reference for this argument. Missing `</p>` tags can seriously screw up a CSS based layout in certain circumstances, as I discovered the hard way.

So the *correct* way to call `as_HTML()` is like this:

    :::perl
    $w_tree->as_HTML('<>&','    ',{});

### TreeBuilder Tip 4: Don't use `as_XML()` unless you *really* mean it
If you are producing XHTML code, you might be tempted to call `as_XML()` instead of `as_HTML()` to serialize your tree. And you would be correct. But remember that XML is *very strict* about how things must be structured, and TreeBuilder complies with this strictness.

One of the sneaky things that will bite you is that in XHTML, script tags have a content model of PCDATA. This means that a *correct* XML generator must encode entities contained by the tag. And if this happens (as it will if you call `as_XML()`), your Javascript just got completely mangled and will no longer run. (Unless, of course, you used the magic incantation to wrap your script contents in CDATA sections.) You can read more about the issues on [Moz Dev][]. However, I found the safest route was to output HTML 4.01 instead. Using an HTML 4 DOCTYPE still triggers standards mode in web browsers, but doesn't have all the [pitfalls of serving XHTML][XHTML].

### TreeBuilder Tip 5: HTML::Element::Library
I discovered this too late to use it myself, but [HTML::Element::Library][] extends HTML::Element with some finger-saving shortcuts. Several times I ended up writing a code stanza that looked like this:

	:::perl
	my $e = $tree->look_down(id => 'replaceMe');
	$e->delete_content();
	$e->push_content($replacement);

With HTML::Element::Library, you can do this instead:

    :::perl
    $tree->look_down(id => 'replaceMe')->replace_content($replacement);

## TreeBuilder Pros and Cons

I think TreeBuilder was the the right tool for the job I had to do. It allowed me to manipulate HTML documents at the server *without* embedding code-specific markers in the document itself. This allowed my team to generate both HTML and server-side Perl code in parallel, and we met our targets with room to spare.

That said, I don't think I would want to use TreeBuilder as my regular template tool. Binding logic to the HTML structure using procedural Perl takes a lot more code than just embedding it into the template. More code means more typing, more testing, and more bugs. [HTML::Seamstress][] tries to help, and certainly should be considered if you are using more than one or two templates with this method, but Seamstress doesn't eliminate code so much as generate it for you. Better, but still not what I want.

What I *really* want is a concise, declarative syntax for binding logic to the document structure. No, not XSLT. I said "concise". I can definitely write Perl code faster than XSLT, and the resulting code is shorter and easier to read.

What would be nice is something very like a CSS stylesheet, but with code blocks instead of style attribute assignments inside the curly braces. Or maybe just a Perl port of jQuery. That would be *way* cool. Anybody want to build that for me?

## Pop culture note
For those too young to remember, "Pop quiz, hotshot", "What do you do?", and "Shoot the hostage" are references to the 1994 action movie <a href="http://www.amazon.com/gp/product/B0006GANOQ?ie=UTF8%26tag%3Dcontrolescape-20%26linkCode%3Das2%26camp%3D1789%26creative%3D9325%26creativeASIN%3DB0006GANOQ">Speed</a><img src="http://www.assoc-amazon.com/e/ir?t=controlescape-20%26l%3Das2%26o%3D1%26a%3DB0006GANOQ" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />, a classic of my generation.

[CPAN]: http://search.cpan.org
[HTML::TreeBuilder]: http://search.cpan.org/dist/HTML-Tree/
[HTML::Entities]: http://search.cpan.org/perldoc?HTML%3A%3AEntities
[Moz Dev]: http://developer.mozilla.org/en/docs/Properly_Using_CSS_and_JavaScript_in_XHTML_Documents
[XHTML]: http://hixie.ch/advocacy/xhtml
[HTML::Element::Library]: http://search.cpan.org/perldoc?HTML::Element::Library
[HTML::Seamstress]: http://search.cpan.org/perldoc?HTML::Seamstress


