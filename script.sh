#!/bin/bash

#   this is a shell script to setup your epitech repo made by Mathieu CHERPITEL
#   make sure to check the -h usage option to use the script
#   in case you find any bugs or possible upgrades, make sure to post a pull request
#   on the gitub of the project https://github.com/MathieuCherpitel/prepare_my_repo


#   this scripts handle help flag such as :
#   Help         :  -h
#   Setup help   :  -s
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
#                   -c++
#                   -python

#####################################
#            DOCUMENTATION          #
#####################################
#   prints the security infos
print_security_info()
{
    echo "SECURITY"
    echo "Curently in this version, the EPITECH password of the user is stocked in a file called .info"
    echo "this file is protected by the super user rights but in order to protect it and to read it, the script must ask you for your root password."
    echo "This means that if you don't restart your terminal, your EPITECH password is vulnerable for 5 minutes (effect time of super user)."
    echo "Also the only easier way to get your password is to find your root password, make sure to have a safe one"
    echo "I will be working on an encryption method for the next updates, make sure to check the github of the project if you find any interesting security issue/ideas."
    exit
}

#   print infos (-h flag)
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
    if [ "$1" == "-s" ]
    then
        print_security_info
    fi
}

#####################################
#         FIRST INITIALISATION      #
#####################################
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

#   gets the user infos and remove acces rights to non root users
init_setup()
{
    cd ~/.setup_repo_v3
    echo "Setup_repo v3 does not seems to be set up for more info use --info"
    echo "Enter your Epitech adress :"
    read login
    if [ $login == "--info" ]
    then
        print_security_info
        init_setup
    fi
    touch info
    #   we are putting the user infos in a file to ask them only once
    echo "$login" >> info
    echo "Enter your Password"
    read -s password
    if [ $login == "--info" ]
    then
        print_security_info
        init_setup
    fi
    echo "$password" >> info

    ##  It would be nice to crypt the password here before putting it in a file

    #   for secutiry reasons, we remove access rights to non root users to prevent then from reading the file
    #   the user must make sure that his root password is strong enought to protect his EPITECH login
    #   we also hide this file
    chmod o-r info
    chmod u-r info
    chmod g-r info
    mv info .info
    echo "Your setup my repo is now set-up"
}

#   checks the mandatories files
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
    if [ ! -f ~/.setup_repo_v3/.info ]
    then
        init_setup
    fi
}

#####################################
#         SUPER QUICK SETUP         #
#####################################
super_quick_setup()
{
    mail=sudo sed -n 1p ~/.setup_repo_v3/.info
    password=sudo sed -n 2p ~/.setup_repo_v3/.info
    echo $mail
    echo $password
}

#####################################
#             MAIN BODY             #
#####################################

#   log as root user
#   this is necessary to read the .info protected file
#   keep in mind that if you do not restart your terminal, your password is vulnerable for 5 minutes (see sudo use and print security info)
sudo sleep 0

#   Init
#   flags possibles : -h -s
check_help $1
#   checking the mandatory files and if needed creates the info file
check_files

#   Check super quick setup option
if [ "$1" == "sq" ]
then
    super_quick_setup
    exit
fi
#   Check flags
get_setup_option