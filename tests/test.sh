#!/usr/bin/env sh
# Integration test for the cookiecutter.
# Creates a project with the cookiecutter and tests that:
# * The documentation builds
# * The test_reminder test fails as expected
# * All other tests pass
# * The main.py script executes successfully

set -xe

CURRENT_DIR=$(pwd)
PROJECT_DIR="test_project${TOX_ENV_NAME}"

rm -rf $PROJECT_DIR

uvx cookiecutter --no-input --default-config \
  -o $PROJECT_DIR \
   . \
  author_name="Joe Doe" \
    author_email="joe@example.com" \
    github_username="jdoe" \
    project_name="My Project" \
    project_short_description="This is a test project." \
    version="1.2.3" \
    license="MIT"
echo "✅ Cookiecutter executes successfully."

cd $PROJECT_DIR/my_project

git add .
git config --local user.name "Joe Doe"
git config --local user.email "joe@example.com"
git commit -m "Initial commit" --no-verify

uv run pre-commit run --all-files
echo "✅ Commit hooks installed and working."

# check that we can run the project
uv run python -m my_project.main
echo "✅ main.py script executes successfully."

# check that the documentation builds without warnings
make docs
echo "✅ Documentation builds."

# check that the tests pass (apart from the test_reminder which always fails)
make test
echo "✅ The tests pass."

# check the github workflow locally

if command -v act > /dev/null 2>&1; then
  make test-github-actions
  echo "✅ Github workflow succeeds (linting, tests, docs)."
else
  echo "⚠️ 'act' command not found. Skipping GitHub workflow tests."
fi


cd "${CURRENT_DIR}"

rm -rf $PROJECT_DIR

echo "✅ Cookiecutter project tested successfully. All good 🤩"
