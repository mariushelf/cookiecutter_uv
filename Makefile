.PHONY: test

test:
	./tests/test.sh

test-all:
	tox p

test-template-git:
	rm -rf the_template_project/.git
	cd the_template_project && git init && git config user.name "gitauthor" && git config user.email "gitmail" && git add . && git commit -m "Initial commit" --no-verify

clean-template:
	cd the_template_project && make clean && cd ..
	rm -rf the_template_project/.venv
	rm -rf the_template_project/.git

test-template-locally: test-template-git
	cd the_template_project && uv run pre-commit install && uv run pre-commit run --all-files && make test && make docs && make build

test-template-act: test-template-git
	cd the_template_project && act --artifact-server-path /tmp/artifacts --action-offline-mode --container-architecture linux/amd64

test-template: test-template-locally test-template-act clean-template

update-template: clean-template
	rm -rf "{{ cookiecutter.project_slug }}" tmp_template
	cp -a the_template_project tmp_template
	find tmp_template -type f | tr '\n' '\0' | xargs -0 -n1 sed -i '' 's/AUTHOR_NAME/\{\{ cookiecutter.author_name \}\}/g; s/the_template_project/\{\{ cookiecutter.project_slug \}\}/g; s/AUTHOR@EMAIL/\{\{ cookiecutter.author_email \}\}/g; s/AUTHOR_EMAIL/\{\{ cookiecutter.author_email \}\}/g; s/PROJECT_NAME/\{\{cookiecutter.project_slug\}\}/g; s/GITHUB_USERNAME/\{\{ cookiecutter.github_username \}\}/g; s/PROJECT_SHORT_DESCRIPTION/\{\{ cookiecutter.project_short_description \}\}/g'
	mv tmp_template/src/the_template_project "tmp_template/src/{{ cookiecutter.project_slug }}"
	mv tmp_template/tests/test_the_template_project.py "tmp_template/tests/test_{{ cookiecutter.project_slug }}.py"
	mv tmp_template "{{ cookiecutter.project_slug }}"
