#!/usr/bin/env bash

function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

echo -e "\e[1;44;93mPivotal Tracker Git Hook Installer\e[0m"
echo -e "This will automagically add the story url as part of your commit message."
echo "Please remember to formulate your branch names in the given format:"
echo -e "\e[1;93mType\e[0m-\e[92mid\e[0m-(optional)other-text\e[0m"
echo "EG:"
echo "bugfix-123456"
echo "feature-98765-new-feature-added"
echo ""
echo "Branch names with invalid formats will be ignored"
echo ""
echo "Checking dependencies..."
pass=0
printf "Checking if \e[1mgit\e[0m is installed..."
if [ $(program_is_installed 'git') == 0 ];
then
    echo -e "\e[1;91m Fail \e[0m"
    pass=1
else
    echo -e "\e[1;92m Pass \e[0m"
fi
printf "Checking if \e[1mPython\e[0m is installed..."
if [ $(program_is_installed 'python') == 0 ];
then
    echo -e "\e[1;91m Fail \e[0m"
    pass=1
else
    echo -e "\e[1;92m Pass \e[0m"
fi

echo ""

if [ "${pass}" == 1 ];
then
    echo -e "\e[1;41;15mPlease make sure all denpencencies are installed and try again.\e[0m"
    exit
fi

current=$(git config --global --get init.templatedir)
default=~/.git-templates

if [ "${current}" == "" ];
then
    echo "Setting up new templates"
    if [[ ! -e $default ]];
    then

        mkdir -p $default
    fi
    echo "Copying base template"
    cp -r /usr/share/git-core/templates/. "${default}"
    current=$default
    git config --global init.templatedir "${current}"
fi

echo "Adding hook"
cp --backup=existing ./commit-msg.py "${current}/hooks/commit-msg"
chmod 775 "${current}/hooks/commit-msg"

echo "Installation complete"
echo -e "Please be sure to run \e[1m'git init'\e[0m in your current git directories"
