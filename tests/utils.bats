#!/usr/bin/env bats

# must run `poetry run cookiecutter . --overwrite-if-exists --no-input base_dir="$PWD"` first
load "test_helper"

@test "goto_alphabet_issues" {
  goto_alphabet_issues
  assert_equal "$PWD" "$alphabet_issue_dir"
}

@test "alphabet_new_retro" {
  assert_equal '1' $(ls $alphabet_retro_dir | wc -l)
  alphabet_new_retro
  assert_equal '2' $(ls $alphabet_retro_dir | wc -l)
}
