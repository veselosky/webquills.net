---
ID: 34  
Itemtype: Item/Page/Article
Title: ORM - PITA?  
Slug: orm-pita  
GUID: tag:www.webquills.net,2008:/scroll//1.24  
disqus_url: http://www.webquills.net/scroll/2008/06/orm-pita.html
Published: 2008-06-14 19:25:35     
Tags: [ORM, perl]  
...

# ORM - PITA?
Recently I read a note called [DBIx::Class Gotchas][gotchas] over at [Perl Alchemy][]. I've been struggling myself for several months with a bundle of old [Class::DBI][] code, and I can relate. Both packages fall into the category of Object-Relational Mapping (ORM), software that tries to map programming objects around entities stored in a relational database.

For a long time I was a huge proponent of ORM software, and I still am for certain types of projects. But the honeymoon is over for me, as I've started to hit some of those limitations they always warn you about. ORM buys you a big gain in productivity, because the software reduces database access patterns from a dozen lines of code to just one or two. If you need to get a small project up and running fast, ORM is a tool that can help a great deal.

The trouble with ORM is that your objects don't always map directly to the queries you want to make. To simplify the thorny problem of SQL generation, often the underlying implementation is doing things in Perl code that would be more efficiently done in the database, or executing multiple SQL queries when a single join would have done the trick. When your project gets very large, very complex, or very dependent on database performance, the ORM layer suddenly seems to hinder as much as it helps. I now spend as much of my time coding *around* the ORM layer as using it.

Still, without ORM I would spend a lot more time writing "select * from table" queries and the like, and I almost always have the need to optimize for development time rather than execution time. So I have this love/hate relationship.

What's your experience with ORM software? Love it? Hate it? Tolerate it?

[gotchas]: http://perlalchemy.blogspot.com/2008/06/dbixclass-gotchas.html
[Perl Alchemy]: http://perlalchemy.blogspot.com/
[Class::DBI]:http://search.cpan.org/dist/Class-DBI/



