load test_helper

@test "show help exits with status code 2" {
    run "$file" -h
    (( status == 2 ))
}

@test "help shows copyright" {
    [[ $("$file" -h) =~ Copyright: ]]
}

@test "help shows license" {
    [[ $("$file" -h) =~ License: ]]
}

@test "license is GPLv3" {
    regex='Released under the GNU General Public License'
    regex+='.*version 3 of the License'
    [[ $("$file" -h | fmt -w 1000) =~ $regex ]]
}
