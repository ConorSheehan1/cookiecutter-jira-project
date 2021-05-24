# Local/Dev install
```bash
poetry install
poetry run cookiecutter .
# poetry run cookiecutter . --overwrite-if-exists --no-input
```

# Tests
```bash
bats $(find ./tests -name '*.bats' | sort)

# alias for the above, can also be used
poetry run task tests
```

# Version management
```bash
# pass args e.g. patch, minor, major, choose to commit changes or not
poetry run bumpversion patch

# to commit changes and create tag immediately
# poetry run bumpversion --commit --tag patch
```