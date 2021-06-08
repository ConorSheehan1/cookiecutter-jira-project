#!/bin/bash

# template version 0.1.0

{{cookiecutter.project_name|lower}}_repo_dir="{{cookiecutter.repo_dir}}"
# TODO: get basedir instead of passing in as arg
{{cookiecutter.project_name|lower}}_issue_dir="{{cookiecutter.base_dir}}/{{cookiecutter.project_name|lower}}/issues"
{{cookiecutter.project_name|lower}}_issue_log="${{cookiecutter.project_name|lower}}_issue_dir/issue_log"
{{cookiecutter.project_name|lower}}_retro_dir="{{cookiecutter.base_dir}}/{{cookiecutter.project_name|lower}}/retro"

goto_{{cookiecutter.project_name|lower}}_issues() {
  cd "${{cookiecutter.project_name|lower}}_issue_dir" || return 1
}

goto_{{cookiecutter.project_name|lower}}_current_issue() {
  current_issue=$(tail -n 1 "${{cookiecutter.project_name|lower}}_issue_log")
  cd "${{cookiecutter.project_name|lower}}_issue_dir/$current_issue" || return 1
}

{{cookiecutter.project_name|lower}}_current_issue() {
  tail -n 1 "${{cookiecutter.project_name|lower}}_issue_log"
}

{{cookiecutter.project_name|lower}}_new_issue() {
  # note this is case sensitive
  regex="^{{cookiecutter.jira_code}}-([0-9]+)(.*)+"
  if [[ ! $1 =~ $regex ]]; then
    echo "$1 must match $regex"
    return 1
  fi

  new_issue_dir="${{cookiecutter.project_name|lower}}_issue_dir/$1"
  new_issue_tech_design="$new_issue_dir/tech.md"

  echo "$1" >> "${{cookiecutter.project_name|lower}}_issue_log"
  cd "${{cookiecutter.project_name|lower}}_repo_dir" || return 1
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" stash save "pre $1"
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" checkout master
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" pull
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" checkout -b "$1"
  echo making "$new_issue_dir"
  mkdir "$new_issue_dir"
  mkdir "$new_issue_dir/screenshots"
  touch "$new_issue_tech_design"
  # open dir to see all files too
  {{cookiecutter.editor}} "$new_issue_dir" "$new_issue_tech_design"
}

{{cookiecutter.project_name|lower}}_new_retro() {
  d=$(date +'%Y-%m-%d')
  retro_template="${{cookiecutter.project_name|lower}}_retro_dir/retro_template.md"
  num_retros=$(find ${{cookiecutter.project_name|lower}}_retro_dir -type f | wc -l | tr -d ' ')
  new_retro="${{cookiecutter.project_name|lower}}_retro_dir/retro_${num_retros}_${d}.md"
  echo "creating $new_retro"
  # TODO: check if file with date exists, should never collide due to incrementing number
  if [ -f "$new_retro" ]; then
    echo "$new_retro already exists."
    exit 1
  fi
  cp "$retro_template" "$new_retro"
  # open dir to see all files too
  {{cookiecutter.editor}} "${{cookiecutter.project_name|lower}}_retro_dir" "$new_retro"
}