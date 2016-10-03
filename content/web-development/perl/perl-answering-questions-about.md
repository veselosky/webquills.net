ID: 28  
Title: Perl Tool Tip: module_info  
Basename: perl-answering-questions-about  
GUID: tag:www.webquills.net,2008:/scroll//1.18  
Created: 2007-12-30 09:03:23  
Updated: 2008-02-18 21:53:59  
Published: 2008-02-18 21:45:00     
Category: Perl  

# Perl Tool Tip: module_info

When developing and deploying Perl code that relies heavily on CPAN modules (and if yours doesn't, it's either really simple, or you are not using Perl to its full potential), I find myself asking the same set of questions over and over again.

* Do I have ${ModuleX} installed on this machine?
* What version of ${ModuleX} is installed?
* There might be more than one copy of ${ModuleX}. Which one is my code using?
* ${ModuleX} is not behaving. I want to have a look at its source.

A handy (and free) tool to help answer these questions is available from CPAN in the [Module::Info][] distribution. In addition to the library, this distribution also includes the `module_info` command line script. Run it to find out the version and location of the module in question. For example:

	vince@Vince-Laptop:~$ module_info Module::Info
	
	Name:        Module::Info
	Version:     0.310
	Directory:   /Library/Perl/5.8.6
	File:        /Library/Perl/5.8.6/Module/Info.pm
	Core module: no

You can quickly find out what version of the module is installed, where it lives, and even whether it is a part of the Perl core distribution. Sadly, `Module::Info` itself is *not* in the Perl core, so you'll have to install it and its dependencies from CPAN.

If you can't install the CPAN module for some reason, I hacked together a little script I call `qmod` that I could carry around on a thumb drive with my dot-files and such. Being just a quick hack, it's not as functional as `module_info`, but it gets the job done. Here it is in its entirety (less documentation).

	#!/usr/bin/perl
	use strict;
	my $max = 0;
	my @list;
	for (@ARGV) {
	    $max = length($_) > $max ? length($_) : $max;
		eval  "require $_;" ;
		if ( $@ ) {
	        push @list, [$_, 'Not Found', ''];
		} else {
			my ($version,$file,$which);
	        ($file = "$_.pm") =~ s{::}{/}g; 
			my $varname = $_ . "::VERSION";
			eval "\$version = \$$varname;";
	        push @list, [$_, $version, $INC{$file}];
		}#END if
	}#END for
	printf "%-${max}s  %6s  %s \n", @{$_} for @list;

If you just need to know the location of a module file, here's a nice tip from brian d foy's <a href="http://www.amazon.com/gp/product/0596527241?ie=UTF8&amp;tag=controlescape-20&amp;linkCode=as2&amp;camp=1789&amp;creative=9325&amp;creativeASIN=0596527241">Mastering Perl</a><img src="http://www.assoc-amazon.com/e/ir?t=controlescape-20&amp;l=as2&amp;o=1&amp;a=0596527241" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />: `perldoc -l Module::Info`.

[Module::Info]: http://search.cpan.org/dist/Module-Info/




