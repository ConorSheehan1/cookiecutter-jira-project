# cookiecutter-jira-project
[![Build Status](https://github.com/ConorSheehan1/cookiecutter-jira-project/workflows/ci/badge.svg)](https://github.com/ConorSheehan1/cookiecutter-jira-project/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A [cookiecutter](https://github.com/audreyr/cookiecutter) template for creating a directory structure and bash scripts to help manage jira projects.

# Usage
To create a new project using this cookiecutter template:

```bash
pip install cookiecutter poetry
cookiecutter gh:ConorSheehan1/cookiecutter-jira-project

# To get the most out of the template, source utils.sh e.g.
# .bashrc
# source your_project_dir/utils.sh
```

For full cookiecutter instructions see https://github.com/audreyr/cookiecutter#features

## Local/Dev install
```bash
poetry install
poetry run cookiecutter .
# poetry run cookiecutter . --overwrite-if-exists --no-input
```
