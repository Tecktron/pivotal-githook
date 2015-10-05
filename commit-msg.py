#!/usr/bin/env python
#
# This git hook will automagically append the pivotal tracker
# story URL to each commit message, if the branch is properly named.
# This takes place after a successful commit message is save, otherwise 
# the commit is properly aborted.

import sys, re
from subprocess import check_output

# Collect the parameters
commit_file = sys.argv[1]

message = ""

# open and read the file
file = open(commit_file, 'r+')
line = file.readline()
while line:
    # strip out comments as we don't want to count them (they'll be removed anyway).
    line = line.strip()
    if line[0] != '#':
        message += line

    line = file.readline()

# with comments striped out, if the message is empty, abort commit
if message == "":
    file.close()
    exit(1)

# find the ID from out branch name
branch = check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip()
regex = "-([0-9]+)[-]*"
match = re.search(regex, branch)
# If there is no match, then just exit and proceed as normal
if not match:
    file.close()
    exit(0)

url = "https://www.pivotaltracker.com/story/show/{}".format(match.group(1))

# don't add the url twice (for amending)
match = re.search(url, message)
if not match:
    message += "\n" + url
    file.seek(0,0)
    file.write(message)
    file.close()

exit(0)
