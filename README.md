# Project Name: git-report.sh
## Introduction
Have you ever wanted to present a nicely-formatted daily report of your
repository activity to someone? I have, and so I wrote git-report.sh to scratch
a few personal and professional itches. It started out as a quick-and dirty set
of Bash hacks, but it has evolved into a nicely-templated system that is easy to
modify, and so I've decided to share it with the world under the GPLv3 license.

You are welcome to modify the script and the template to suit your needs,
provided that you follow the terms of the license and contribute back any
improvements you make to code that you redistribute. You're also welcome to
participate in other ways, such as suggesting improvements or submitting pull
requests (along wiht unit tests, of course) to make the software better.

I hope you find this tool useful, and look forward to receiving your feedback
and constructive criticism.

## Copyright and Licensing
### Copyright Notice
The copyright for the software, documentation, and associated files are held by
the author.

    Copyright 2009-2015 Todd A. Jacobs
    All rights reserved.

The AUTHORS file is also included in the source tree.

### Software License
![GPLv3 Logo]
The software is licensed under the [GPLv3 License]. The LICENSE file is included
in the source tree.

### README License
![Creative Commons BY-NC-SA Logo][CC Logo]

This README is licensed under the [Creative Commons
Attribution-NonCommercial-ShareAlike 3.0 United States License][CC License].

## Purpose
Provide a snapshot of work done within a Git repository, nicely formatted for
reporting to managers who like that sort of thing.

## Options
- `-h = show documentation`
- `-u = show usage`

## Usage
- `git-report.sh [-h|-u]`
- `git-report.sh ["optional_note_string"]`

## Environment Variables
- *EMAIL*

    default: `git config user.email`

- *START*

    default: midnight that started the current day

- *END*

    default: midnight that ends on the current day

## Examples
### Daily Report
    $ ./git-report.sh
    ----------------------------------------------------------------------
    Repository Report for [foo-project]
    Start: Fri Apr 10 00:00:00 EDT 2015, End: Fri Apr 10 23:59:59 EDT 2015
    ----------------------------------------------------------------------

    Notes:
        N/A

    Commits (1):
        d221bb3 Refactor bar into baz.

    Lines of code:
        287

    Files modified (1):
        README.md

    Tickets worked on:
        #123

    Tickets completed:
        N/A

### Multi-Day Report with Notes
    $ START='yesterday' ./git-report.sh 'Wow, what a busy two days!'
    ----------------------------------------------------------------------
    Repository Report for [busy-project]
    Start: Fri Apr 10 00:00:00 EDT 2015, End: Sat Apr 11 23:59:59 EDT 2015
    ----------------------------------------------------------------------

    Notes:
        Wow, what a busy two days!

    Commits (2):
        4f1e01a Update file for [#3].
        d221bb3 Start ticket #4.
        f20dfc6 Finish #2.

    Lines of code:
        406

    Files modified (2):
        README.md
        foo.sh

    Tickets worked on:
        #3
        #4

    Tickets completed:
        #2

## Contributing
Contributions in the form of pull requests are welcome. Pull requests must
include valid test cases using Sam Stephenson's handy [Bash Automated Testing
System][bats].


[CC License]: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
[CC Logo]: http://i.creativecommons.org/l/by-nc-sa/3.0/us/88x31.png
[GPLv3 License]: http://www.gnu.org/copyleft/gpl.html
[GPLv3 Logo]: http://www.gnu.org/graphics/gplv3-88x31.png
[bats]: https://github.com/sstephenson/bats

<!-- vim: set tw=72 sw=4 ft=markdown: -->
