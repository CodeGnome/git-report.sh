#!/usr/bin/env bash
# vim: sw=4:tw=72:ai:et

## Purpose:
##     Provide a snapshot of work done within a Git repository, nicely
##     formatted for reporting to managers who like that sort of thing.
##
## Copyright:
##     Copyright 2009-2015 Todd A. Jacobs
##
## License:
##     Released under the GNU General Public License (GPL)
##     <http://www.gnu.org/copyleft/gpl.html>.
##
##     This program is free software; you can redistribute it and/or
##     modify it under the terms of the GNU General Public License as
##     published by the Free Software Foundation; either version 3 of the
##     License, or (at your option) any later version.
##
##     This program is distributed in the hope that it will be useful,
##     but WITHOUT ANY WARRANTY; without even the implied warranty of
##     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##     General Public License for more details.
##
## Usage:
##     git-report.sh
##     git-report.sh [-h|-u]
##
## Options:
##     -h = show documentation
##     -u = show usage
##
## Environment Variables
##     - EMAIL # default: `git config user.email`
##     - START # default: midnight that started the current day
##     - END   # default: midnight that ends on the current day

set -e

# Use GNU utilities on OS X.
if [[ $(uname -s) == Darwin ]]; then
  date () { gdate "$@"; }
  sed  () { gsed  "$@"; }
fi

######################################################################
# CONSTANTS
######################################################################
DIGITS='#[[:digit:]]+'
SPACE=' '
TAB=$'\t'

: ${EMAIL:=$(git config user.email)}
: ${START:=$(date -R -d '12:00am today')}
: ${END:=$(date -R -d '12am + 1 day - 1 second')}
export EMAIL END START

######################################################################
# Functions
######################################################################
commits_in_range () {
    git log                  \
        --oneline            \
        --author="$EMAIL"    \
        --committer="$EMAIL" \
        --all                \
        --since="$START"     \
        --until="$END"       \
    | sed 's/^/\t/'
}

files_modified () {
    git whatchanged          \
        --author="$EMAIL"    \
        --committer="$EMAIL" \
        --branches           \
        --since="$START"     \
        --until="$END"       \
    | egrep '^:'             \
    | awk '{print $NF}'      \
    | sort -du               \
    | sed 's/^/\t/'
}

lines_of_code () {
    git log                  \
        --all                \
        --author="$EMAIL"    \
        --committer="$EMAIL" \
        --since="$START"     \
        --until="$END"       \
        --numstat            \
    | awk '/^[0-9]/ {LOC+=$1; LOC+=$2}; END {print LOC}'
}

print_report_header () {
    local start=$(date -d "$START")
    local end=$(date -d "$END")
    printf -v dashes "%*s" $LINE_LENGTH
    echo ${dashes// /-}
    echo "Repository Report for [$REPO_NAME]"
    echo "Start: $start, End: $end"
    echo ${dashes// /-}
}

# Tickets marked as finished.
tickets_completed () {
    local regex="(finish|close|fix).*${DIGITS}"
    git log \
        --author="$EMAIL"    \
        --committer="$EMAIL" \
        --branches           \
        --since="$START"     \
        --until="$END"       \
        --extended-regexp    \
        --regexp-ignore-case \
        --grep="$regex"      \
    | egrep -o "$DIGITS"     \
    | sort -u \
    | sed 's/^/\t/'
}

# All tickets listed in commit range.
tickets_worked () {
    local regex="^start.*${DIGITS}|ticket $DIGITS|\[${DIGITS}\]"
    git log \
        --author="$EMAIL"    \
        --committer="$EMAIL" \
        --branches           \
        --since="$START"     \
        --until="$END"       \
        --regexp-ignore-case \
        --extended-regexp    \
        --grep="$regex"      \
    | egrep -o "$DIGITS"     \
    | sort -u                \
    | sed 's/^/\t/'
}

show_help ()  {
    local format help lines_of_text screen_height

    # Extract help from current script file.
    help=$(
        format='%s\n    %s\n\n'
        printf "$format" "Program Name:" $(basename "$0")
        egrep '^##([^#]|$)' $0 | sed -r 's/^## ?//'
    )

    # Use PAGER unless unset or piping standard output.
    screen_height=$(tput lines)
    lines_of_text=$(echo "$help" | wc -l)
    if [[ -t 1 ]] && [[ $screen_height -lt $lines_of_text ]]; then
        echo "$help" | "${PAGER:-more}"
    else
        echo "$help"
    fi
    exit 2
}

show_usage () {
  local USAGE_LINES=2
  local TAB=$'\t'

  # Change format depending on number of lines.
  if (( $USAGE_LINES > 1 )); then
    echo "Usage: "
  else
    unset TAB
    echo -n "Usage: "
  fi

  # Display usage information parsed from this file.
  egrep -A ${USAGE_LINES} "^## Usage:" "$0" \
      | tail -n ${USAGE_LINES} \
      | sed -e "s/^##[[:space:]]*/$TAB/"
  exit 2
}

# Process options.
while getopts ":hu" opt; do
    case $opt in
        h)
            show_help
            ;;
        \? | u)
            show_usage
            ;;
    esac # End "case $opt"
done # End "while getopts"

# Shift processed options out of the way.
shift $(($OPTIND - 1))

######################################################################
# Report Template
######################################################################
# Populate variables for the report.
COMMITS=$(commits_in_range)
COMMIT_COUNT=$(commits_in_range | wc -l | tr -d "$SPACE")
FILES_MODIFIED=$(files_modified)
FILEMOD_COUNT=$(files_modified | wc -l | tr -d "$SPACE")
LINE_LENGTH=70
LINES_OF_CODE=$(lines_of_code)
NOT_APPLICABLE=$'\t'"N/A"
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
REPORT_NOTES=$(echo -e "\t${1:-N/A}" | fmt -w $LINE_LENGTH)
TICKETS_COMPLETED=$(tickets_completed)
TICKETS_WORKED=$(tickets_worked)

cat << EOF
$(print_report_header)

Notes:
$(echo "$REPORT_NOTES" | fmt -w $LINE_LENGTH)

Commits ($COMMIT_COUNT):
${COMMITS:-$NOT_APPLICABLE}

Lines of code:
${LINES_OF_CODE:+$TAB}${LINES_OF_CODE:-$NOT_APPLICABLE}

Files modified ($FILEMOD_COUNT):
${FILES_MODIFIED:-$NA}

Tickets worked on:
${TICKETS_WORKED:-$NOT_APPLICABLE}

Tickets completed:
${TICKETS_COMPLETED:-$NOT_APPLICABLE}
EOF
