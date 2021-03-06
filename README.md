# cookiecutter-jira-project
[![Build Status](https://github.com/ConorSheehan1/cookiecutter-jira-project/workflows/ci/badge.svg)](https://github.com/ConorSheehan1/cookiecutter-jira-project/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tested python versions](https://img.shields.io/badge/dynamic/yaml?url=https://raw.githubusercontent.com/ConorSheehan1/cookiecutter-jira-project/master/.github/workflows/ci.yml&label=Tested%20python%20versions&query=$.jobs.build.strategy.matrix.python)](https://github.com/ConorSheehan1/cookiecutter-jira-project/blob/master/.github/workflows/ci.yml#L27)
[![OS](https://img.shields.io/badge/dynamic/yaml?url=https://raw.githubusercontent.com/ConorSheehan1/cookiecutter-jira-project/master/.github/workflows/ci.yml&label=OS&query=$.jobs.build.strategy.matrix.os)](https://github.com/ConorSheehan1/cookiecutter-jira-project/blob/master/.github/workflows/ci.yml#L26)


A [cookiecutter](https://github.com/audreyr/cookiecutter) template for creating a directory structure and bash scripts to help manage jira projects.

# Usage
To create a new project using this cookiecutter template:

```bash
pip install cookiecutter
cookiecutter gh:ConorSheehan1/cookiecutter-jira-project
```

For full cookiecutter instructions see https://github.com/audreyr/cookiecutter#features

### utils.sh

To get the most out of the template, source utils.sh e.g.

```shell
.bashrc
source "$your_project_dir/utils.sh"
```

Provides the following functions
1. `goto_$your_project_repo`
    1. cd to repo dir
1. `goto_$your_project_issues`
    1. cd to issue dir
1. `goto_$your_project_current_issue`
    1. cd to current issue dir
1. `$your_project_current_issue`
    1. echo current issue
1. `$your_project_new_issue`
    1. stash changes
    1. pull master
    1. create new branch (defaults to feature/$issue_name)
    1. create new issue dir
    1. open in editor
1. `$your_project_new_retro`
    1. create retro from template
    1. open in editor

# Development
See [dev.md](./dev.md)
