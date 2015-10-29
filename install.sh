#!/bin/bash

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
        local result=1 #linux
    elif [ $1 == 'Darwin' ];
    then
        local result=2 #mac
    fi
    echo $result
}

OS=`uname`
OS_TYPE=$(os_check $OS)

if [ "${OS_TYPE}" == 0 ];
then
    echo "Sorry, your OS is not supported. Goodbye."
    exit 8;
fi

printf "\e[1;44;93mPivotal Tracker Git Hook Installer\e[0m\n"
printf "This will automagically add the story url as part of your commit message.\n"
printf "Please remember to formulate your branch names in the given format:\n"
printf "\e[1;93mType\e[0m-\e[92mid\e[0m-(optional)other-text\e[0m\n"
printf "EG:\n"
printf "bugfix-123456\n"
printf "feature-98765-new-feature-added\n"
printf "\n"
printf "Branch names with invalid formats will be ignored\n"
printf "\n"
printf "Checking dependencies...\n"
pass=0
printf "Checking if \e[1mgit\e[0m is installed..."
if [ $(program_is_installed 'git') == 0 ];
then
    printf "\e[1;91m Fail \e[0m\n"
    pass=1
else
    printf "\e[1;92m Pass \e[0m\n"
fi
printf "Checking if \e[1mPython\e[0m is installed..."
if [ $(program_is_installed 'python') == 0 ];
then
    printf "\e[1;91m Fail \e[0m\n"
    pass=1
else
    printf "\e[1;92m Pass \e[0m\n"
fi

printf "\n"

if [ "${pass}" == 1 ];
then
    printf "\e[1;41;15mPlease make sure all dependencies are installed and try again.\e[0m\n"
    exit
fi

# Get the current setting if one exists
current=$(git config --global --get init.templatedir)
default=~/.git-templates

if [ "${current}" == "" ];
then
    printf "Setting up new templates\n"
    printf "Searching for base git directory..."
    # Search the usr directory for the git templates directory
    base=$(find /usr -mount -type d -wholename "*git-core/templates*" | head -n1)
    if [ "${base}" == "" ];
    then
        printf "\e[1;41;15mCould not find base git directory. Please try a manual install.\e[0m\n"
        exit
    else
        printf "found at ${base}\n"
        printf "\n"
    fi

    if [[ ! -e $default ]];
    then
        mkdir -p $default
    fi
    printf "Copying base template\n"
    cp -r "${base}/." "${default}"
    current=$default
    git config --global init.templatedir "${current}"
    # Mac cp doesn't support --backup like linux , so we manually do this here.
    if [ "${OS_TYPE}" == 2 ];
    then
        if [[ -e "${current}/hooks/commit-msg" ]];
        then
            mv "${current}/hooks/commit-msg" "${current}/hooks/commit-msg.old"
        fi
    fi
fi

printf "Adding hook\n"
if [[ $OS_TYPE == 1 ]];
then
    cp --backup=existing ./commit-msg.py "${current}/hooks/commit-msg"
else
    cp ./commit-msg.py "${current}/hooks/commit-msg"
fi
chmod 775 "${current}/hooks/commit-msg"


read -p "Do you want me to install the hook for you [Y/n]?" dosearch
dosearch=${dosearch,,}
if [[ "${dosearch}" != 'n' ]];
then
    find $HOME -type d -name ".git" -print0 | while read -d $'\0' gitdir;
    do
        #skip anything in the trash
        if [[ ! "${gitdir}" =~ 'Trash' ]];
        then
            #remove the .git portion of the directory string
            currentGit=$(dirname "${gitdir}")
            #check to see if the old hook exists and remove it
            hook="${gitdir}/hooks/commit-msg"
            if [[ -e "${hook}" ]];
            then
                rm "${hook}"
            fi
            #reinitalize the directory
            git init "${currentGit}"
         fi
    done
else
    printf "Please be sure to run \e[1m'git init'\e[0m in your current git directories\n"
    printf "If you are updating, please be sure to remove the old hook from \n"
    printf "the .git/hooks directory in each of your repos before running init.\n"
fi

printf "Installation complete\n"


