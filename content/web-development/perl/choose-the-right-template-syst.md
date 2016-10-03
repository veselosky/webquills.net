ID: 29  
Title: Choose the right template system for your team  
Basename: choose-the-right-template-syst  
GUID: tag:www.webquills.net,2008:/scroll//1.19  
disqus_url: http://www.webquills.net/scroll/2008/01/choose-the-right-template-syst.html
Created: 2008-01-29 22:58:18  
Updated: 2009-05-15 07:42:07  
Published: 2008-01-29 22:53:18     
Tags: Templates  
Category: Perl  

# Choose the right template system for your team
What is the best template system? Ask five people and you'll probably get six different answers. Perl has more than its fair share of template tools, from the Swiss Army Chainsaw of [Template Toolkit][], through [HTML::Mason][] and [Text::Template][] down to the ever-tempting "variables interpolated in a here-doc" method.

As always with this type of question, there is no "correct" answer. The best template system is the one that works best for you, in your circumstances. If you are the only programmer in a room full of professional designers, your optimal template choice is likely to be different than if you are just trying to stick a loop into a text file for your own cron job. 

In my experience, the key factors in choosing a template system are usually the composition of your development team, and the development workflow. Who has to work with the templates, and what are their skill sets? Is the code being designed around the interface, or is the interface being pasted on top of the code?

Read on for a comparison of the major template systems in Perl, and my recommendations of which systems fit which circumstances.

## Solo Perl Hacker: Text::Template

If you are a Perl programmer and you are producing your own templates, whether they be an HTML front-end or a plain text email, you can hardly go wrong by starting with [Text::Template][]. This is the shortest path from Perl code to output, short of variable interpolation in a double-quoted string. The syntax is just plain old Perl, and everything you know about Perl translates directly to effective templates.

The down-side, of course, is that you do not enforce a clear separation of concerns. As a programmer intimately familiar with the internals of your application, you will be tempted to embed all sorts of application logic into the templates themselves. This makes your application harder to test and harder to maintain.

There is nothing in Text::Template that forces you to mix business logic into your templates or to write unmaintainable code, but it doesn't go out of its way to encourage modularity or cleanliness either. For larger projects, meaning either lots of templates or several programmers, you may consider a more complex solution that enforces some rules. (Template Toolkit might be a good step up, read below.) But for quick and dirty (or quick and clean) templates, Text::Template is awesome. Also, if your application is *not* a web application, this is a good place to start.

## Perl Team, Web App: HTML::Mason

[HTML::Mason][] is an excellent solution for a small team of Perl programmers writing their own HTML. Although it is not limited to HTML (it works fine with any kind of text), Mason excels at web development. It ships with a light-weight web framework of its own, although it can also be plugged into web frameworks like [Catalyst][]. 

Like Text::Template, Mason works by embedding Perl into your templates, so Perl programmers can pick it up fairly quickly. Much of Mason's added syntax is geared around triggering code at different points in the request cycle, and creating time-saving features like automatic wrapping of content with layout components that are "inherited" based on the directory hierarchy. 

Mason allows you to think about HTML design like a *programmer*, decomposing a web site into reusable components that are effectively Perl objects, each with its own methods and variable scope. This makes it highly effective for code-centric applications, where the HTML is built after the primary program logic.

Mason is not necessarily the best system for HTML designers who are not Perl hackers. Because it encourages decomposition into components, you rarely have a template that represents a complete HTML document. Mason's syntax uses pseudo-tags to demarcate embedded logic, which tends to upset HTML-centric design tools.

I find Mason to be especially useful for applications where I need to create a web interface to some existing data store, such as a SQL database created by another application. Combined with a clean database access layer like [DBIx::Class][], you can get from legacy database to structured web front-end extremely quickly.

I'm a big Mason fan, and I encourage you to visit [Mason HQ][] to give it a try.

## Dedicated HTML Coder: HTML::Template or Template Toolkit

If your team has designers who are good with mark-up but not experienced programmers, then you probably want a template system that will insulate them from program logic while giving them the flexibility to construct simple loops and conditionals. 

[HTML::Template][] is a good choice for the mark-up coder who is less programmatically inclined. Its syntax is close to HTML, which flattens the learning curve, and it doesn't expose too many internal moving parts that would be hard to learn and easy to break. On the other hand, the syntax is *so* similar to HTML that HTML editing tools might see it as bad mark-up and complain about it. As with Mason, your templates will almost certainly not validate on their own. (As a programmer, I find the functional limitations frustrating.)

If your HTML expert is also comfortable writing Javascript code (or some other non-Perl language like Java, Python, or Ruby), you might shift toward [Template Toolkit][]. TT allows you to use program objects in the template using a Javascript-like dot syntax, and gives a bit more flexibility in logical constructs. TT also has the advantage that it can scale to large and complex template sets, and its numerous plugins give you a lot of usage options. Template instructions will not be confused with HTML mark-up, either by humans or editing tools, so if you're careful you can get your unprocessed templates to validate.

## Fancy-pants Designers vs. Engineers: Template Toolkit, Petal, Template::TAL

If your web application is heavily design-oriented, what your designers want from you is probably what they might describe as "server-side Javascript". That is, you are probably working from a design first, and building program logic to hang functionality onto the design.

Template Toolkit can fit pretty well into this kind of process. It makes sense to designers familiar with Javascript or some other programming language, and the more programmatically inclined designers enjoy exercising program logic in their templates. But not all designers are programmatically inclined. I refer to these types (lovingly) as "fancy-pants" designers.

Typically, fancy-pants designers will start with a "wireframe" sketch and move up to fully elaborated Photoshop mocks of their web designs. Only after working in this form for several iterations will they start to generate an HTML model of the design. Their first goal is to create an HTML model that exactly mimics their Photoshop images, including sample text and images in the content areas. This helps them to visually prove that their designs will display correctly in a web browser (vitally important for a design-intensive web application).

Using Template Toolkit or any of the above template solutions adds a step to the design workflow where the HTML model must be dismantled, and bits of pretty HTML filler replaced with unattractive template tags and symbols. Most designers don't care for this, because it makes it more difficult to visualize the product as it was meant to be viewed. Design changes that come *after* this transformation can be painful, because the designers usually have to go back to their mocked HTML model to visualize the changes, and then they (or you) must repeat the dismantling and replacement process.

[Petal][] and [Template::TAL][] are potential solutions to this problem. (Both are Perl ports of a Python tool, [Zope Template Attribute Language][TAL].) Their technique solves the problem by hiding template instructions in the HTML as extra attributes on proper HTML tags. Designers can feel free to fill the template with sample text and images that will make the template display cleanly in any web browser or HTML editing tool. Instead of taking this filler away, they (or you) *add* template instructions that dictate how the filler should be replaced by the output of program objects when the template is processed. Using namespaces, this can result in templates that are valid XHTML documents.

## And the winner is...

What have we learned? When choosing a template system, you must consider the needs of the team as a whole, not just the software developers. Any of these solutions might be perfect for your team and your workflow.

But since you insist: My personal favorite is [HTML::Mason][]. I've been using it to build web applications for years. The community is very supportive, I'm comfortable with it's quirks, and most importantly, I'm extremely productive with it. However, if you currently have no experience with any of these template systems, and you want to learn only *one* system, I recommend you pick up [Template Toolkit][]. It has a vibrant community around it, which I consider a must for any tool I use. You can get started quickly. And you can reasonably use it in small, simple applications as well as large complex ones, so it leaves you plenty of room to grow.

If I forgot to mention *your* favorite template system, I'm sorry. I can only write about what I know, and these are the template systems that I am familiar with. Feel free to plug your own favorite solution in the comments!

[Catalyst]: http://catalyst.perl.org
[DBIx::Class]: http://search.cpan.org/dist/DBIx-Class/
[HTML::Mason]: http://search.cpan.org/dist/HTML-Mason/
[HTML::Template]: http://search.cpan.org/dist/HTML-Template/
[Mason HQ]: http://www.masonhq.com
[Petal]: http://search.cpan.org/perldoc?Petal
[TAL]: http://wiki.zope.org/ZPT/TAL
[Template Toolkit]: http://search.cpan.org/dist/Template-Toolkit/
[Template::TAL]: http://search.cpan.org/perldoc?Template::TAL
[Text::Template]: http://search.cpan.org/dist/Text-Template/

