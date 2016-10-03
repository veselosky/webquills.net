ID: 45  
Title: 10 Things I Love/Hate About Movable Type  
Basename: 10-things-i-lovehate-about-mov  
GUID: tag:www.webquills.net,2009:/scroll//4.45  
disqus_url: http://www.webquills.net/scroll/2009/05/10-things-i-lovehate-about-mov.html
Created: 2009-05-03 18:31:07  
Updated: 2009-05-03 18:33:14  
Published: 2009-05-03 18:30:45
Category: Perl  
Description: In which our hero counts off the list of inspirations and irritations encountered while blogging with Movable Type.  

# 10 Things I Love/Hate About Movable Type
I have a love/hate relationship with my blogging tool. Here are ten aspects of Movable Type about which I am emotionally conflicted.

1.  **Love:** Movable Type is implemented in Perl. Yay, Perl!  
    **Hate:** Movable Type is implemented in "old school" Perl, not [Modern Perl][]. (But they are working on that, thanks MT team!)

1.  **Love:** Movable Type's publishing engine supports many publishing modes, including scheduled posts, and publishes static HTML files by default for efficient hosting.  
    **Hate:** The only option for dynamic publishing is - PHP? Seriously? Sorry MT, I fully understand the business reasons behind this, but as a Perl developer, it still offends me.

1.  **Love:** Movable Type is themeable.  
    **Hate:** The default theme is ugly. Replacement themes are not much better, so I'm still using the default.

1. **Love:** Movable Type fully supports post metadata, without overwhelming you with interface inputs (not a unique feature of MT, but a nice one).  
    **Hate:** MT has three distinct metadata items called Categories, Tags, and Keywords. Each behaves differently, despite the fact that they all *mean* approximately the same thing to a user. (Tip: Categories generate pages. Tags do not, but are searchable. Keywords are basically useless.)

1.  **Love:** Input filters allow you to compose your posts using [Markdown][], [Textile][], or plain HTML.  
    **Hate:** The built-in editor is just as clunky as all web-based editors (a problem not unique to MT). But worse, it feels "bolted on" rather than integrated into the blogging system. For example, there is no tool to easily create links to other posts. If you want to link to a previous post, you have to go look up the URL yourself (which is not easy due to the information architecture of the site, see below).

1.  **Love:** Plugins and The Registry - Everything revolves around this central "registry" data structure. Once you understand that structure and how to tweak it, you can do some pretty cool things without a lot of code. As a matter of fact, you don't even need to write Perl anymore, you can just drop a yaml file in a directory and it gets slurped into the data structure.  
    **Hate:** Managing plugins is a huge pain. In order for them to work you have to mix the plugin files with the original MT code in the same directory. You're never really sure if you're overwriting something, and if you do, you're SOL. Upgrading MT or one of the plugins also becomes painful, because it's hard to tell which files are core and which plugin. I took to managing mine with [stow](http://www.gnu.org/software/stow/), which made it livable, but still horrible. Plus, half the plugins available only work with the ancient MT3, not the more modern MT4.

1.  **Love:** The flexible template system. Once you get the hang of it, it's easy to make template tags produce all kinds of nifty things. And it is possible (though not trivial) to create new tags via plugins if you need additional functionality.  
    **Hate:** Templates are stored in the database by default, not the file system. This means you have to use the clunky MT template editor to edit them any time you change, or use the clunky MT template editor to edit every single template individually to force them to live in the filesystem. (Or write a script to fix it.) And you have to remember to do this every time you create a new blog too.
    
1.  **Love:** Every template is customizable, and you can make as many as you want.  
    **Hate:** As soon as you customize a template, you have to start worrying about your changes getting clobbered if you "refresh" to get new MT templates, which you really have to do if you want to take advantage of new MT features. (At least MT makes backups for you by default. But since they are stored in the database and not the filesystem, they are a pain to deal with.)

1.  **Love:** Movable Type supports multiple blogs/sites in the same installation, and as a result it is possible to craft queries in your templates that aggregate multiple blogs.  
    **Hate:** Each blog always gets its own separate set of templates based on an original core set. Sharing individual templates across blogs is hard. Sharing a whole set of templates requires bending over backwards and nibbling your heels. Making an identical set of changes to identical non-shared templates requires a custom Perl script, or the patience of Job.

1.  **Love:** Movable Type's default template set is built with web standards: XHTML, CSS, and even [microformats][], with [progressive enhancement][] in Javascript.  
    **Hate:** The information architecture of the default template set is terrible. Navigation is stuck into a sidebar down the page instead of up front. Pages that list posts always include the full text of a post rather than just a pointer, making exploration and discovery difficult. The whole site architecture seems to have been inherited unchanged from whatever protozoic blog first emerged from the muck back in the Paleo-web of the "Dot Com Bubble" era.

Glad I got that off my chest. What's *your* boggle?

[Modern Perl]: http://www.modernperlbooks.com/mt/2009/01/why-modern-perl.html
[Markdown]: http://daringfireball.net/projects/markdown/
[Textile]: http://textile.thresholdstate.com/
[microformats]: http://microformats.org/about/
[progressive enhancement]: http://en.wikipedia.org/wiki/Progressive_enhancement




