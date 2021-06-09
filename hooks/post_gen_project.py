
base_dir = '{{cookiecutter.base_dir}}'
project_name = '{{cookiecutter.project_name}}'
repo_dir = '{{cookiecutter.repo_dir}}'
project_path = f'{base_dir}/{project_name}'

print(f'\033[0;32mSuccessfully generated {project_path}\033[0m')
print('\033[0;33mTo make the utility functions available in your shell, source utils.sh. e.g.\033[0m')
print(f'\techo "source {project_path}/utils.sh" >> ~/.bashrc')

print()
print('\033[0;33mTo setup git hooks run the following:\033[0m')
print(f'\tln -s {project_path}/githooks/commit-msg {repo_dir}/.git/hooks/commit-msg')