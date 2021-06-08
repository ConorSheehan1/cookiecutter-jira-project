#!/usr/bin/env bats

load "test_helper"

@test "goto_alphabet_issues" {
  goto_alphabet_issues
  assert_equal "$PWD" "$alphabet_issue_dir"
}

@test "alphabet_new_retro" {
  # only the template exists
  assert_equal '1' $(ls $alphabet_retro_dir | wc -l)

  alphabet_new_retro
  # the template and the new retro exists
  assert_equal '2' $(ls $alphabet_retro_dir | wc -l)
}

@test "alphabet_new_issue_fail_regex" {
  # only issue_log exists
  assert_equal '1' $(ls $alphabet_issue_dir | wc -l)

  # need run to assert failure
  run alphabet_new_issue "asdf"

  assert_output "asdf must match ^ABC-([0-9]+)(.*)+"

  # no issue created, only issue_log exists
  assert_equal '1' $(ls $alphabet_issue_dir | wc -l)
  assert_failure
}

@test "alphabet_new_issue" {
  # only issue_log exists
  assert_equal '1' $(ls $alphabet_issue_dir | wc -l)

  alphabet_new_issue "ABC-123"

  # should be on new branch
  assert_equal "ABC-123" $(git -C $alphabet_repo_dir symbolic-ref --short HEAD)

  # should create tech design file
  assert_file_exist "$alphabet_issue_dir/ABC-123/tech.md"

  # should have exactly 2 directories in issues, the template and the new issue (ABC-123)
  assert_equal '2' $(ls $alphabet_issue_dir | wc -l)
}

# @test "alphabet_new_issue_stash" {
#   touch "$alphabet_repo_dir/asdf"

#   alphabet_new_issue "ABC-223"
#   # should have stashed changes if they exist
#   assert_equal "stash@{0}: pre ABC-223asdf" $(git -C $alphabet_repo_dir --no-pager stash list -1)
# }