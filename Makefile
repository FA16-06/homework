MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

################
# Environment variables

ifndef ENTR_BIN
ENTR_BIN := $(firstword $(shell which entr 2>/dev/null))
endif

################
# Sanity checks and local variables

use_watcher := 0
ifneq ($(ENTR_BIN),)
use_watcher := 1
endif

################
# Standard targets

.PHONY: all
all: gen/specification.pdf

.PHONY: run
run:
ifeq ($(use_watcher),1)
	+$(MAKE) -j 2 server watcher
else
	+$(MAKE) -j 2 server all
endif

.PHONY: depend
depend:
	npm install

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

gen:
	mkdir -p $@

gen/specification.css: base.css specification/make_css.py | gen
	{ cat $(word 1,$^); python3 $(word 2,$^); } > $@

gen/specification.pdf: specification/index.md gen/specification.css | gen
	./node_modules/.bin/markdown-pdf \
		--out $@ \
		--paper-format A4 \
		--css-path $(word 2,$^) \
		$< 2>/dev/null
