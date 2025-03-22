.PHONY: test

test:
	./tests/test.sh

test-all:
	tox p

test-template-git:
	rm -rf the_template_project/.git
	cd the_template_project && git init && git config user.name "gitauthor" && git config user.email "gitmail" && git add . && git commit -m "Initial commit" --no-verify

test-template-clean:
	rm -rf the_template_project/.git

test-template-locally: test-template-git
	cd the_template_project && uv run pre-commit install && uv run pre-commit run --all-files

test-template-act: test-template-git
	cd the_template_project && act --artifact-server-path /tmp/artifacts --action-offline-mode --container-architecture linux/amd64

test-template: test-template-locally test-template-act test-template-clean
