load test_helper

@test "show usage" {
    [[ $("$file" -u) =~ Usage: ]]
}

@test "usage exits with status code 2" {
    run "$file" -u
    (( status == 2 ))
}

@test "show help" {
    [[ $("$file" -h) =~ Purpose: ]]
}
