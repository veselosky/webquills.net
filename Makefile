#######################################################################
# Makefile for building this web site.
#
# I'm not a Make magician so there's lots of room for improvement. The
# strategy is to convert input files to a standard JSON format, then
# use the JSON to create an index and provide variables to the templates.
#
# Currently only support Markdown sources, but any source format can be
# used if you can build a source to json converter. If you do, you'll
# need to adjust the JSONPOSTS declaration.
#######################################################################

SHELL := /bin/bash

# Inventory the source files, make list of dest files to target
# ERROR: Assumes there are no JSON files without Markdown sources.
JSONPOSTS = $(shell find content -name "*.md" | sed s/content/build\\/html/ | sed s/.md/.json/)
POSTS = $(JSONPOSTS:.json=.html)
BUILDDIR = "build/html"
CONTENTDIR = "content"

#######################################################################
# Build targets and rules
#######################################################################
.PHONY: clean-pyc clean-build docs clean json html posts

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "site - build the entire web site"
	@echo "json - build only the data files for the site, no html"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"


# Just an easy target to type, to build out all json files
# json: build/html/_index.json
json:
	@mkdir -p $(BUILDDIR)
	@cp -a $(CONTENTDIR)/ $(BUILDDIR)/
	@UPDATES=() ; \
	for mdown in `find $(BUILDDIR) -name '*.md'`; do \
		if [ ! -e "$${mdown/%.md/.json}" ] ; then \
			UPDATES+=($$mdown); \
		elif [ "$$mdown" -nt "$${mdown/%.md/.json}" ] ; then \
			UPDATES+=($$mdown); \
		fi \
	done; \
	[ -z "$$UPDATES" ] || quill md2json -i $${UPDATES[@]}
	@if [ -e $(BUILDDIR)/_index.json ] ; then \
		JSON=`find $(BUILDDIR) -name '*.json' -newer $(BUILDDIR)/_index.json`; \
		[ -z "$$JSON" ] || quill index -A $(BUILDDIR)/_index.json $$JSON; \
	else \
		JSON=`find $(BUILDDIR) -name '*.json'`; \
		[ -z "$$JSON" ] || quill index -A $(BUILDDIR)/_index.json $$JSON; \
	fi

html: json
	quill render `find $(BUILDDIR) -name '*.json'`

# HTML pages are produced by feeding a context to a template. The context is
# constructed from the post JSON file, the index, and a site-wide variables
# file.
build/html/%.html: build/html/%.json templates/blog.html site.yml
	./bin/j2.py -r build/html -t templates blog.html site.yml $(@:.html=.json) > $@

posts: json templates/blog.html site.yml $(POSTS)

build/html/archive.html: templates/archive.html build/html/_index.json
	./bin/j2.py -r build/html -t templates archive.html site.yml build/html/_index.json > $@

build/html/categories.html: templates/categories.html build/html/_index.json
	./bin/j2.py -r build/html -t templates categories.html site.yml build/html/_index.json > $@

build/html/feeds/recent.atom: json
	@mkdir -p $(@D)  # `dirname $@`
	./bin/mkfeed.py -r build/html build/html/_index.json > $@

pages: build/html/archive.html build/html/categories.html

feed: build/html/feeds/recent.atom

site: posts pages feed
	mkdir -p build/html/assets
	cp -r static/* build/html/assets/
	cp -r extra/* build/html/
# TODO combine and minify CSS, JS
# TODO List of index pages. How to manage these?


clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/

test:
	python setup.py test

test-all:
	tox

deploy:
	test -e ~/.aws/*.pem && ssh-add ~/.aws/*.pem
	ansible-playbook -i ~/Google\ Drive/Websites/ansible_inventory_for_statics.ini deploy.yml

clean:
	rm -fr build/*


