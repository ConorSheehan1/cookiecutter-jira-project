#!/bin/bash

{{cookiecutter.jira_code}}_repo_dir="{{cookiecutter.repo_dir}}"
# TODO: get basedir
{{cookiecutter.jira_code}}_issue_dir="$HOME/Documents/notes/rtls/{{cookiecutter.jira_code}}/issues"
{{cookiecutter.jira_code}}_current_issue_file="${{cookiecutter.jira_code}}_issue_dir/current_issue"
{{cookiecutter.jira_code}}_retro_dir="$HOME/Documents/notes/rtls/{{cookiecutter.jira_code}}/retro"

goto_{{cookiecutter.jira_code}}_issues() {
  cd ${{cookiecutter.jira_code}}_issue_dir || exit
}

goto_{{cookiecutter.jira_code}}_current_issue() {
  current_issue=$(tail -n 1 "${{cookiecutter.jira_code}}_current_issue_file")
  cd "${{cookiecutter.jira_code}}_issue_dir/$current_issue" || exit
}

{{cookiecutter.jira_code}}_current_issue() {
  tail -n 1 "${{cookiecutter.jira_code}}_current_issue_file"
}

{{cookiecutter.jira_code}}_new_issue() {
  regex="^{{cookiecutter.jira_code}}-([0-9]+)(.*)+"
  if [[ ! $1 =~ $regex ]]; then
    echo "$1 must match $regex"
    return 1
  fi

  new_issue_dir="${{cookiecutter.jira_code}}_issue_dir/$1"
  new_issue_tech_design="$new_issue_dir/tech.md"

  echo "$1" >> "${{cookiecutter.jira_code}}_current_issue_file"
  cd "${{cookiecutter.jira_code}}_repo_dir" || exit
  git stash save "pre $1"
  git checkout master
  git pull
  git checkout -b "$1"
  echo making "$new_issue_dir"
  mkdir "$new_issue_dir"
  mkdir "$new_issue_dir/screenshots"
  touch "$new_issue_tech_design"
  # open dir to see all files too
  code "$new_issue_dir" "$new_issue_tech_design"
}

{{cookiecutter.jira_code}}_new_retro() {
  d=$(date +'%Y-%m-%d')
  retro_template="${{cookiecutter.jira_code}}_retro_dir/retro_template.md"
  num_retros=$(find ${{cookiecutter.jira_code}}_retro_dir -type f | wc -l | tr -d ' ')
  new_retro="${{cookiecutter.jira_code}}_retro_dir/retro_${num_retros}_${d}.md"
  echo "creating $new_retro"
  # TODO: check if file with date exists, should never collide due to incrementing number
  if [ -f "$new_retro" ]; then
    echo "$new_retro already exists."
    exit 1
  fi
  cp "$retro_template" "$new_retro"
  # open dir to see all files too
  code "${{cookiecutter.jira_code}}_retro_dir" "$new_retro"
}