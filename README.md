# pivotal-githook
This is a githook for pivotal tracker

This will automagically append the story url as part of your commit message.

## Usage

When provided with a properly formulated branch name, the id will be stripped and turned into a url and appended to your commit messages.
This makes it easy for anybody looking though your commits, to find out what the issue fix was pertaining to.

In order to use this, branches should be named in the following manner:
- (Type of issue)-(id of issue from pivotal)

If you wish to add more detail to the branch name you can use
- (Type of issue)-(id of issue from pivotal)-(any other text goes here)

EG:
- bugfix-123456
- feature-98765-new-feature-added

Branch names with invalid formats will be ignored and commit messages will be left alone.

## Requirements
- git, should be able to run git on the commandline
- python, version 2+ is supported. The hook is written in python, so it should be able to run as a script.

## Installation

- git clone the repo onto your local machine
- Run the install.sh file.

This will check dependencies and create or add to (with backup) the necessary git templates.

Once the install is complete, you simply need to run `git init` (this will not delete anything) in your existing repositories to install the hook. New repos will automatically have it.

If you run into any problems, please try the manual install below, open an issue or make a pull request.

**Please Note:** Currently the installation script is *not compatible with windows*. To install on windows, please follow the manual install instructions below. However, you should note that you may have to create a wrapper around the the python file in order for ir to properly run.

## Manual Install

Make sure that the requirements are met. 
If you already have a template directroy installed, then simply copy the commit-msg.py hook into the hooks directory and remove the .py

The rest of this guide will help you set up a git template directory with the hook in it

1. Find where the git templates are. On OSX and Linux this is usually somewhere in the /usr folder.You can try and run this command to find it: `find /usr -mount -type d -wholename "*git-core/templates*" | head -n1` but if that doesn't work, you may need to manually search. For windows machines this is typically somewhere in the C:\Program Files\Git folder.
2. Create a directory in your home folder to place the new template, in this case I'll be using `~/.git-templates`. Windows users, this is probably less important to you (you can just skip to step 5 if you don't care to move the default location), but you can make this in /users/[name]/git-templates if you like (where [name] is your current user).
3. Copy the contents of the git templates directory we found in step 1 into the folder we created in step 2.
4. Set git to use the template directory we just created `git config --global init.templatedir ~/.git-templates`. You may need to change the actual directory based on what you did for step 2.
5. Copy the commit-msg.py file into the hooks subdirectory in to the new templates directory and remove the .py extension. (Windows users, please see the notes in the regular install section)
6. That's is, you're done. Make sure that the commit-msg is executable (non-windows) and remember to run `git init` in your current git repos.


