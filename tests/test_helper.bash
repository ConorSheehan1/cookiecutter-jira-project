#!/bin/bash
# https://github.com/rbenv/rbenv/blob/4e923221ce57a04ab52bddd638473d566347711f/test/test_helper.bash#L1

flunk() {
    { if [ "$#" -eq 0 ]; then cat -
        else echo "$@"
        fi
    } | sed "s:${BATS_TEST_DIRNAME}:TEST_DIR:g" >&2
    return 1
}

assert_success() {
    # status is same as $?, returns status code of last command.
    # shellcheck disable=SC2154
    if [ "$status" -ne 0 ]; then
        flunk "command failed with exit status $status"
    elif [ "$#" -gt 0 ]; then
        assert_output "$1"
    fi
}

assert_failure() {
    if [ "$status" -eq 0 ]; then
        flunk "expected failed exit status"
    elif [ "$#" -gt 0 ]; then
        assert_output "$1"
    fi
}

assert_equal() {
    if [ "$1" != "$2" ]; then
        { echo "expected: '$1'"
          echo "actual:   '$2'"
        } | flunk
    fi
}

assert_match() {
    if ! [[ "$2" =~ $1 ]]; then
        {
            echo "expected '$2' to match '$1'"
        } | flunk
    fi
}

assert_partial() {
    if [[ "$2" == *"$1"* ]]; then
        {
            echo "expected '$1' to be in '$2'"
        } | flunk
    fi
}


assert_output() {
    local expected
    if [ $# -eq 0 ]; then expected="$(cat -)"
    else expected="$1"
    fi
    assert_equal "$expected" "$output"
}

assert_line() {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        assert_equal "$2" "${lines[$1]}"
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" = "$1" ]; then return 0; fi
        done
        flunk "expected line \`$1'"
    fi
}

refute_line() {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        local num_lines="${#lines[@]}"
        if [ "$1" -lt "$num_lines" ]; then
            flunk "output has $num_lines lines"
        fi
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" = "$1" ]; then
                flunk "expected to not find line \`$line'"
            fi
        done
    fi
}

assert() {
    if ! "$@"; then
        flunk "failed: $@"
    fi
}

setup_example_files() {
    # make temp directory and example files
    target_dir=$(mktemp -d '/tmp/examples_XXX')
    # # https://github.com/sstephenson/bats/issues/191
    # if [[ "$DEBUG" == 'true' ]]; then
    #     run bash -c "(>&2 echo $target_dir)"
    # fi
    touch "$target_dir/first.EXAMPLE"
    touch "$target_dir/second.example"
}

# find files without any extension
# relies on setup_example_files not including extra extensions
list_non_example_files() {
    find "$1" -type f ! -iname "*.*"
}

# run script from bash_scripts root dir, relative to test dir.
run_relative() {
    run bash -c "${BATS_TEST_DIRNAME}/../$1"
}

# https://github.com/bats-core/bats-core/issues/39#issuecomment-377015447
setup() {
    example_dir="alphabet"

    # only run before first test
    if [[ "$BATS_TEST_NUMBER" -eq 1 ]]; then
        # check if dir already exists, if it does delete it
        if [ -d "$example_dir" ]; then
            rm -rf "$example_dir"
        fi
        # setup example project so utils.sh exists and can be tested
        poetry run cookiecutter . --overwrite-if-exists --no-input base_dir="$PWD"
    fi

    # load functions to be tested
    load "$example_dir/utils.sh"
}

# teardown() {
#     if [[ "${#BATS_TEST_NAMES[@]}" -eq "$BATS_TEST_NUMBER" ]]; then
#         # TODO: fix teardown, failing multiple runs
#         rm -rf "../alphabet"
#     fi
# }