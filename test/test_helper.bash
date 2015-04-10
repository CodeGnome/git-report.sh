setup () {
    export PATH="$PWD:$PATH"
    export file="$PWD/git-report.sh"

    export TMPDIR=/tmp
    export test_dir=$(mktemp -d -t git)

    cd "$test_dir"
    git init

    # Test fixtures:
    #   - 1 empty commit.
    #   - 2 files committed with one line of code each.
    #   - 2 lines of code altogether.
    #   - 3 total commits.
    # Note that some tests may add or modify this basic set of fixtures.
    git commit --allow-empty --message='Empty initial commit.'

    echo foo_data > foo
    git add foo
    git commit -m 'Start #1.'

    echo bar_data > bar
    git add bar
    git commit -m 'Finish #1.'

    # Export expected values for use in tests.
    export expected_lines_of_code=2
    export expected_number_of_commits=3
}

teardown () {
  rm -rf "$test_dir"
}
