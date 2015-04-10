load test_helper

@test "Tickets worked section displayed" {
    run "$file"
    str="Tickets worked on"
    [[ $output =~ $str ]]
}

@test "Tickets worked on are displayed" {
    git commit --allow-empty -m 'Start #2'
    regex='#[[:digit:]]+'
    wip=$(
        "$file" |
        fgrep -A1 'Tickets worked' |
        egrep -o "$regex"
    )
    [[ "$wip" =~ $regex ]]
}
