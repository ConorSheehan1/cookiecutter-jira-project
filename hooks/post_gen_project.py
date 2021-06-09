
base_dir = '{{cookiecutter.base_dir}}'
project_name = '{{cookiecutter.project_name}}'
repo_dir = '{{cookiecutter.repo_dir}}'
project_path = f'{base_dir}/{project_name}'

print(f'\033[0;32mSuccessfully generated {project_path}\033[0m')
print('To load scripts run the following:')
print(f'\techo "load {project_path}/utils.sh" >> ~/.bashrc')