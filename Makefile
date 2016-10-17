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
SITEDIR = $(shell quill config 'options.root')
BUILDDIR = $(dir $(SITEDIR))
STYLES=\
	node_modules/normalize.css/normalize.css \
	node_modules/typeplate-starter-kit/dist/css/typeplate.css \
	themes/posh/style/style.css

#######################################################################
# Build targets and rules
#######################################################################
.PHONY: clean-pyc clean-build docs clean json html posts

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "site - build the entire web site"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"


html:
	quill build

$(SITEDIR)/_T/style.css: $(STYLES)
	mkdir -p $(SITEDIR)/_T/
	cat $(STYLES) | node_modules/clean-css/bin/cleancss --source-map -o $@

stylesheet: $(SITEDIR)/_T/style.css
site: html stylesheet

serve:
	cd $(SITEDIR) && python -mhttp.server

clean:
	rm -fr $(BUILDDIR)

deploy:
	test -e ~/.aws/*.pem && ssh-add ~/.aws/*.pem
	ansible-playbook -i ~/Google\ Drive/Websites/ansible_inventory_for_statics.ini deploy.yml

