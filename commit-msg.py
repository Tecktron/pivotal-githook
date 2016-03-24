#!/usr/bin/env python
#
# This git hook will automagically append the pivotal tracker
# story URL to each commit message, if the branch is properly named.
# This takes place after a successful commit message is save, otherwise
# the commit is properly aborted.
import sys
import re
import os
from subprocess import check_output


def get_message(file_name):
    """
    Retrieves the message of the file without lines that contain comments.
    :param string: file_name
    :return: the message of the text.
    """
    commit_file = open(file_name, 'r')
    text = ""
    line = commit_file.readline()
    while line:
        # strip out comments as we don't want to count them (they'll be removed anyway).
        stripped = line.strip()
        if len(stripped) > 0 and stripped[0] != '#':
            text += stripped + "\n"

        line = commit_file.readline()

    commit_file.close()
    return text


def write_message(message, file_name):
    """
    Writes the new message
    :param message: the message to write
    :param file_name: the filename
    """
    commit_file = open(file_name, 'w')
    commit_file.write(message)
    commit_file.close()


if not sys.argv[1]:
    exit(1)

# find the ID from the branch name
branch = check_output(['git', 'symbolic-ref', '--short', 'HEAD'])
match = re.search('-([0-9]+)[-]*', branch.decode("utf-8").strip())
# If there is no match, then just exit and proceed as normal
if not match:
    exit(0)

# formulate the url from the match
url = "https://www.pivotaltracker.com/story/show/{}".format(match.group(1))

# since we have a match, lets open the file and get the message
commit_file_name = os.getcwd() + "/" + sys.argv[1]
message = get_message(commit_file_name)

# with comments striped out, if the message is empty, abort commit
if message == "":
    exit(1)

# We shouldn't add the url twice (for amending)
match = re.search(url, message)
if not match:
    message += "\n" + url + "\n"
    write_message(message, commit_file_name)

exit(0)
