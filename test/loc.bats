load test_helper

@test "template prints LOC" {
    run "$file"
    str="Lines of code"
    [[ "$output" =~ $str ]]
}

@test "LOC count is accurate" {
    result=$("$file" | fgrep -A1 'Lines of code' | tail -n1)
    (( result == expected_lines_of_code ))
}
