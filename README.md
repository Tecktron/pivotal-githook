# pivotal-githook
This is a githook for pivotal tracker

This will automagically append the story url as part of your commit message.

## Usage

When provided with a properly formulated branch name, the id will be stripped and turned into a url and appended to your commit messages.
This makes it easy for anybody looking though your commits, to find out what the issue fix was pertaining to.

In order to use this, branches should be named in the following manner:
- (Type of issue)-(id of issue)

If you wish to add more detail to the branch name you can use
- (Type of issue)-(id of issue)-(any other text goes here)

EG:
- bugfix-123456
- feature-98765-new-feature-added

Branch names with invalid formats will be ignored and commit messages will be left alone.

## Installation

Run the install.sh file. This will check dependencies and create or add too (with backup) the necessary git templates.

Once the install is complete, you simple need to run *git init* (this will not delete anything) in your existing repositories to install the hook. New repos will automatically have this.

**Please Note:** Currently this is not currently compatible with windows.
