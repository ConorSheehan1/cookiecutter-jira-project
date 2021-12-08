#!/bin/bash

{{cookiecutter.project_name|lower}}_version="0.2.0"

{{cookiecutter.project_name|lower}}_repo_dir="{{cookiecutter.repo_dir}}"
{{cookiecutter.project_name|lower}}_issue_dir="replace_me.base_dir/issues"
{{cookiecutter.project_name|lower}}_issue_log="${{cookiecutter.project_name|lower}}_issue_dir/issue_log"
{{cookiecutter.project_name|lower}}_retro_dir="replace_me.base_dir/retro"

goto_{{cookiecutter.project_name|lower}}_repo() {
  cd "${{cookiecutter.project_name|lower}}_repo_dir" || return 1
}

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

{{cookiecutter.project_name|lower}}_version() {
  echo "${{cookiecutter.project_name|lower}}_version"
}

{{cookiecutter.project_name|lower}}_new_issue() {
  # note this regex is case sensitive
  regex="^{{cookiecutter.jira_code}}-([0-9]+)(.*)+"
  usage="branch_type=feature upstream_branch=master {{cookiecutter.project_name|lower}}_new_issue {{cookiecutter.jira_code}}-123-some-bug"
  if [[ ! $1 =~ $regex ]]; then
    echo "$1 must match $regex"
    echo "usage: $usage"
    return 1
  fi

  branch_type="${branch_type:-"feature"}"
  # https://confluence.atlassian.com/bitbucketserver/branches-776639968.html#Branches-Branchtypes
  # does not include 'release' since they are a branch from trunk and don't need a jira ticket
  if [[ ! $branch_type =~ (feature|bugfix|hotfix) ]]; then
    echo "Warning: invalid branch_type: $branch_type. using default 'feature'"
    branch_type="feature"
  fi
  upstream_branch="${upstream_branch:-"master"}"
  issue_name="$1"
  issue_branch="$branch_type/$issue_name"

  new_issue_dir="${{cookiecutter.project_name|lower}}_issue_dir/$issue_name"
  new_issue_tech_design="$new_issue_dir/tech.md"

  echo "issue_branch=$issue_branch"
  echo "upstream_branch=$upstream_branch"
  echo "new_issue_dir=$new_issue_dir"

  # bash and zsh read aren't compatible, use
  # https://superuser.com/questions/555874/zsh-read-command-fails-within-bash-function-read1-p-no-coprocess/556006
  if [ -z "$no_prompt" ]; then
    echo "Continue?"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) echo 'continuing'; break;;
        No ) echo 'exiting'; return 1;;
      esac
    done
  fi

  echo "$issue_name" >> "${{cookiecutter.project_name|lower}}_issue_log"
  cd "${{cookiecutter.project_name|lower}}_repo_dir" || return 1
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" stash save "pre $issue_branch"
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" checkout "$upstream_branch"
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" pull
  git -C "${{cookiecutter.project_name|lower}}_repo_dir" checkout -b "$issue_branch"
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