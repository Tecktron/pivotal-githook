#!/usr/bin/env bash

function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

function os_check()
{
    local result=0
    if [ $1 == 'Linux' ];
    then
        local result=1
    elif [ $1 == 'Darwin' ];
    then
        local result=2
    fi
    echo $result
}

OS=`uname`
OS_TYPE=$(os_check $OS)

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

base='/usr/share/git-core/templates/.'
if [ "${OS_TYPE}" == 1 ];
then
    base="/usr/local/share/git-core/templates/."
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
    cp -r "${base}" "${default}"
    current=$default
    git config --global init.templatedir "${current}"
    if [ "${OS_TYPE}" == 1 ];
    then
        if [[ -e "${current}/hooks/commit-msg" ]];
        then
            mv "${current}/hooks/commit-msg" "${current}/hooks/commit-msg.sav"
        fi
    fi
fi

echo "Adding hook"
if [[ $OS_TYPE == 0 ]];
then
    cp --backup=existing ./commit-msg.py "${current}/hooks/commit-msg"
else
    cp ./commit-msg.py "${current}/hooks/commit-msg"
fi
chmod 775 "${current}/hooks/commit-msg"

echo "Installation complete"
echo -e "Please be sure to run \e[1m'git init'\e[0m in your current git directories"
