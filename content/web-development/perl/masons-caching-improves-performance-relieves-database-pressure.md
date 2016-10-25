---
ID: 38  
Itemtype: Item/Page/Article
Title: Mason's caching improves performance, relieves database pressure   
Slug: masons-caching-improves-performance-relieves-database-pressure  
GUID: tag:www.webquills.net,2008:/scroll//4.38  
Created: 2008-09-22 20:47:00  
Updated: 2009-05-15 07:35:46  
Published: 2008-09-22 20:41:58     
Tags: [Mason, Templates]  
...

# Mason's caching improves performance, relieves database pressure 

[HTML::Mason](http://www.masonhq.com) is a template system with power tools built in. Here's a case study in the usefulness of Mason's internal caching tools.

## Mason reads from database
As part of a web site registration application, the user is to be presented with a list of email newsletters the site makes available. During registration, the user may select one or more of the newsletters and be automatically subscribed. So I coded up a Mason component to display this list.

    :::HTML
    <%once>
    use ListDB;
    </%once>
    <%init>
    my @newsletters = ListDB::get_mailing_lists();
    </%init>
    % for my $newsletter (@newsletters) {
        <input id="subscribe" type="checkbox" name="subscribe" value="<% $newsletter %>">
        <label for="subscribe"><% $newsletter %></label><br>
    %}

Of course this example is simplified, the real code has more HTML and a bit more display logic. It's not pretty, but it gets the job done. In the `once` section I import the library that interfaces with our mailing list database (which is managed by a separate application). Then we simply get a list of available newsletters and display each with an input checkbox. 

## When database is busy, Apache gets tied up!
As the website and the newsletters became more popular, we began to see problems. Specifically, when the mailing list software was performing some database intensive task, as it frequently did, the simple query underlying the call to `ListDB::get_mailing_lists()` would take a *very* long time to return. As a result, the user had to wait a minute or more for the page to load, and an Apache process was occupied waiting for the database to return.  If we ever had a time when the web site and the database were both busy at the same time, *all* our Apache processes could end up waiting for the database query, leaving none to serve pages. That's bad news for a web site!

The problem here, obviously, is that the code queries the database *every time* a user requests the registration form. This is not a problem that is unique to Mason, all dynamic web applications eventually run into it. Nor is the solution unique to Mason. But Mason makes the solution trivial to implement.

## Mason cache smoothes database bumps
The solution, of course, is to cache the response from the database, so that the next web request does not need to hit the database in order to render the list. The list of newsletters doesn't change very often, so there is no harm in caching it. In fact, since the HTML rendering of the list won't change either, why not cache the HTML and save the rendering next time too?

If only Mason had a built-in cache system so I wouldn't have to go digging around for extra modules on CPAN and write another 20 lines of code. Oh wait, *it does*!

    :::HTML
    <%init>
    return if $m->cache_self(expire_in => 3600); # THE SOLUTION! (ALMOST)
    require ListDB;
    my @newsletters = ListDB::get_mailing_lists();
    </%init>
    % for my $newsletter (@newsletters) {
        <input id="subscribe" type="checkbox" name="subscribe" value="<% $newsletter %>">
        <label for="subscribe"><% $newsletter %></label><br>
    %}

See, I told you Mason makes it easy! You can arrange for any component to cache its output with this simple incantation. If the component has previously been cached, `$m->cache_self` will return a true value, and the component will not execute again. Instead, the output will be fetched from the cache, without any further action on your part. Pretty neat, huh? But that's not all it does. If the component has *not* been previously cached, this routine will set a "hook" that will transparently cache the output of the current component execution once it has finished. Now that's just cool! I'll bet you can guess what the `expire_in` argument does. Yup, I'm telling it to cache the output for 3600 seconds (one hour), if the current cache happens to be empty.

Notice the other change I made. Instead of `use`ing our ListDB library in the `once` section, I have changed to a require statement. Why? Because in the general case, the library will not be needed for as much as an hour, because the content will be served from the cache. To save memory, we don't import the library until after the call the `$m->cache_self`, when we know we'll need it.

## After the cache expires, *le deluge*
Ah, but there's a flaw in your brilliant plan, I hear you say. What happens if the database happens to be slow *just* when the cache expires? You're right back where you started, with an empty cache and a whole bunch of Apache process waiting for data to fill it with.

Doggone it, why do you have to be so observant? I guess I'll have to break another tool out of Mason's bag of tricks. Watch *this*!

    :::HTML
    <%init>
    return if $m->cache_self(expire_in => 3600, busy_lock => 60); # THE SOLUTION!
    require ListDB;
    my @newsletters = ListDB::get_mailing_lists();
    </%init>
    % for my $newsletter (@newsletters) {
        <input id="subscribe" type="checkbox" name="subscribe" value="<% $newsletter %>">
        <label for="subscribe"><% $newsletter %></label><br>
    %}

See what I did there? No? Look again at that first line of the `init` section. The new `busy_lock` argument is the key. Basically, that's telling the Mason cache, "Hey, if this object has expired, extend the life of the old cached value by 60 seconds so other processes will still get a cached value. Meanwhile, I'm gonna calculate a new value and cache that."

Now, when the cache "expires", only *one* Apache process will notice that fact. That one process will proceed to hit the database for the new value. Meanwhile, other processes will continue to find the old value in the cache for another 60 seconds. If the database does happen to be slow, only one user (per minute) will have a problem, and only one apache process will be hung waiting for data.

## HTML::Mason references
* The [Mason home page](http://www.masonhq.com)
* The [Data Caching](http://www.masonhq.com/docs/manual/Devel.html#data_caching) section of the Mason developer guide
* Get "The Mason Book", <a href="http://www.amazon.com/gp/product/0596002254?ie=UTF8&tag=webquills-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0596002254">Embedding Perl in HTML With Mason</a><img src="http://www.assoc-amazon.com/e/ir?t=webquills-20&l=as2&o=1&a=0596002254" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
(also [available online](http://www.masonbook.com/) )
* Get [Mason from CPAN](http://search.cpan.org/dist/HTML-Mason/)




