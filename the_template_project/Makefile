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
	rm -rf .artifacts
	rm -rf .venv

clean_docs:
	cd docs && make clean

test: test-unit-tests test-github-actions

test-unit-tests:
	uv run pytest tests

test-github-actions:
	if command -v act > /dev/null 2>&1; then \
	  act --artifact-server-path .artifacts --action-offline-mode --container-architecture linux/amd64; \
	  echo "✅ Github workflow succeeds (linting, tests, docs)."; \
	else \
	  echo "⚠️ 'act' command not found. Skipping GitHub workflow tests."; \
	fi

docs:
	cd docs && uv run make html
	echo You can now browse the documentation at ./docs/build/index.html

build: docs
	uv build
