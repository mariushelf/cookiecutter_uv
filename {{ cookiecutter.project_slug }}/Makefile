SHELL := /bin/bash

.PHONY: docs

install:
	uv sync

clean: clean_docs
	rm -rf dist
	find . -type d -name __pycache__ | xargs rm -rf
	rm -rf .tox
	rm -rf *cache*
	rm -rf .*cache*


clean_docs:
	cd docs && make clean

test: install
	uv run pytest tests

docs:
	cd docs && uv run make html
	echo You can now browse the documentation at ./docs/build/index.html

build: docs
	uv build
