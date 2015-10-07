#!/usr/bin/env python
#
# This git hook will automagically append the pivotal tracker
# story URL to each commit message, if the branch is properly named.
# This takes place after a successful commit message is save, otherwise 
# the commit is properly aborted.

import sys, re
from subprocess import check_output


def get_message(file):
    """
    Retrieves the message of the file without lines that contain comments.
    :param file:  file
    :return: the message of the text.
    """
    text = ""
    line = file.readline()
    while line:
        # strip out comments as we don't want to count them (they'll be removed anyway).
        line = line.strip()
        if line and line[0] != '#':
            text += line

        line = file.readline()

    return text

if not sys.argv[1]:
    exit(1)

# open and read the file
commit_file = open(sys.argv[1], 'r+')
message = get_message(commit_file)

# with comments striped out, if the message is empty, abort commit
if message == "":
    commit_file.close()
    exit(1)

# find the ID from out branch name
branch = check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip()
regex = "-([0-9]+)[-]*"
match = re.search(regex, branch)
# If there is no match, then just exit and proceed as normal
if not match:
    commit_file.close()
    exit(0)

url = "https://www.pivotaltracker.com/story/show/{}".format(match.group(1))

# don't add the url twice (for amending)
match = re.search(url, message)
if not match:
    message += "\n" + url
    commit_file.seek(0,0)
    commit_file.write(message)

commit_file.close()
exit(0)
