load test_helper

str='Tickets completed:'

@test "Completed tickets section displayed" {
    run "$file"
    [[ $output =~ $str ]]
}

@test "Completed tickets are displayed" {
    git commit --allow-empty -m 'Finish #2'
    regex='#[[:digit:]]+'
    tickets=$(
        "$file" |
        fgrep -A1 "$str" |
        egrep -o "$regex"
    )
    [[ "$tickets" =~ $regex ]]
}

@test "The right number of competed tickets are shown" {
    # Add two completed tickets; one is already a fixture.
    git commit --allow-empty -m '[Finish #2]'
    git commit --allow-empty -m 'Finish #3'
    regex='#[[:digit:]]+'
    run "$file"
    count=$(
        echo "$output" |
        egrep -A3 "$str" |
        egrep -o "$regex" |
        wc -l
    )
    (( count == 3 ))
}
