MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

################
# Environment variables

################
# Standard targets

.PHONY: all
all: gen/specification.pdf

.PHONY: run
run:
	+$(MAKE) -j 2 server watcher

.PHONY: clean
clean:
	rm -rf -- gen *~

################
# My Targets

.PHONY: server
server:
	python3 -m http.server 8888

.PHONY: watcher
watcher:
	entr make all <<<specification/index.md

################
# Source transformations

node_modules: package.json
	npm install

gen:
	mkdir -p $@

gen/specification.css: base.css specification/make_css.py | gen
	{ cat $(word 1,$^); python3 $(word 2,$^); } > $@

gen/specification.pdf: specification/index.md gen/specification.css | gen node_modules
	./node_modules/.bin/markdown-pdf \
		--out $@ \
		--paper-format A4 \
		--css-path $(word 2,$^) \
		$< 2>/dev/null
