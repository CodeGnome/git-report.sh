load test_helper

@test "template prints commits" {
    run "$file"
    str="Commits \([[:digit:]]+\):"
    [[ "$output" =~ $str ]]
}

@test "commit count is accurate" {
    commits=$("$file" | perl -ne 'print $1 if /Commits.*\K(\d+)/')
    "$file" | perl -ne 'print $1 if /Commits.*\K(\d+)/'
    (( commits == expected_number_of_commits ))
}
