#!/bin/bash

#   this is a shell script to setup your epitech repo made by Mathieu CHERPITEL
#   make sure to check the -h usage option to use the script
#   in case you find any bugs or possible upgrades, make sure to post a pull request
#   on the gitub of the project https://github.com/MathieuCherpitel/prepare_my_repo


#   this scripts handle help flag such as :
#   Help         :  -h
#
#   when started, the script will ask you what type of setup you want
#
#   project type :  - graph
#                   - other
#
#   setup option :  - complete
#                   - simple
#   
#   if Complete setup option is selected :
#   Group Project:  - yes
#                   - no
#
#   Language:       -c
#                   -python

check_help() {
    input=$1
    if [ "$1" == "-h" ]; then
        echo "DESCRIPTION:"
        echo "The goal of this script is to setup proprely your git repository for group or solo projects at EPITECH"
        echo "There are several options and conditions that must be known"
        echo "This script will create Makefiles, Gitignores, Folders in your repository by itself"
        echo "but you have to use your own lib that will be copied in your repository."
        echo "to do so, make sure to create a directory named .lib in your home and copy your lib inside"
        echo "You should also make sure that this lib is up-to-date and respects the norm."
        echo ""
        echo "USAGE:"
        echo "When starting the script with no argmuents, it will ask you for differents options"
        echo ""
        echo "OPTIONS DESCRIPTION"
        echo "Project type : "
        echo "  -graph (will create a different Makefile and prepare a folder called assets"
        echo "  -other (normal Makefile with src with a main and inlude folder)"
        echo "Setup Option :"
        echo "  -complete (will ask you if it is a solo/group project and the language used to get a proper gitignore and or Makefile"
        echo "  -simple (will create a c classic Makefile"
        exit
    fi
}

#   if the user puts as arguments sq repo_name we setup a "classic c repo"
super_quick_setup()
{
    if [ -z $2 ]
    then
        echo "missing repo name !"
        exit 0
    fi

    #creates the repo gives access rights and clone 
    blih repository create $2
    blih repository setacl $2 ramassage-tek r
    blih repository getacl $2
    git clone git@git.epitech.eu:/mathieu.cherpitel@epitech.eu/$2 && echo repository created and cloned
    cp -r ~/.setup_repo/lib/* $2 && echo lib copied
    cd $2
}

complete_setup()
{
    echo "complete setup"
}

simple_setup()
{
    #   get login
    cd ~/.setup_repo_v3
    login="$(cat info)"
    openssl rsautl -inkey ~/.setup_repo_v3/key.txt -decrypt <~/.setup_repo_v3/password.bin > soluce
    password="$(cat soluce)"
    rm soluce
    cd -
    echo "login : $login"
    echo "password : $password"
}

#   gets the setup option and calls either simple_setup or complete_setup
get_setup_option()
{
    echo "Enter your Setup Option (complete or simple)"
    read option
    if [ "simple" = "$option" ]
    then
        simple_setup
    elif [ "complete" = "$option" ]
    then
        complete_setup
    else
        echo "invalid option"
        get_setup_option
    fi
}

check_files()
{
    if [ ! -d ~/.setup_repo_v3 ]
    then 
        echo "missing .setup_repo_v3 directory, try to create one in your home and see -s for more info"
        exit
    fi
    if [ ! -d ~/.setup_repo_v3/lib ]
    then
        echo "missing lib directory in ~/.setup_repo try to create one and see -s for more info"
        exit
    fi
    if [ ! -f ~/.setup_repo_v3/info ]
    then
        echo "Setup_repo v3 does not seems to be set up, if it's not true make sure to report the bug via github"
        echo "Enter your Epitech adress :"
        read login
        cd ~/.setup_repo_v3
        echo "$login" >> info
        echo "generating key"
        openssl genrsa -out ~/.setup_repo_v3/key.txt 2048
        echo "Enter your Epitech password (it will be encoded in key.txt file and will not be printed at any time)"
        read password 
        echo "$password" | openssl rsautl -inkey ~/.setup_repo_v3/key.txt -encrypt >~/.setup_repo_v3/password.bin
    fi
}

###########################################
#   this is the main body of the script   #
###########################################
check_files
check_help $1
if [ "$1" == "sq" ]
then
    super_quick_setup $1 $2
fi
get_setup_option