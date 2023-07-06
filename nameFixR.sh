#!/bin/bash

# Author: SoDA-CNE (See No Evil) | ÐAMIAN VΛ
# THIS PROGRAM USES RENAME TO REMOVE STRINGS FROM DIRECTORY AND FILE OBJECTS
# PROVIDE THE FOLDER TO CLEAN AS THE INPUT ARGUMENT
# May 6 2007

# EXAMPLE COMMANDS USED ON DIRECTORIES
#rename -d "String-to-remove" **/* #recursively
#rename -d "String-to-remove" -n **/* #recursively with dry run no modification
#rename -d "String-to-remove" * #top level objects'


# UI/UX COLORS
RED=$(tput setaf 1) # Red
GREEN=$(tput setaf 2) # Green
BLUE=$(tput setaf 4) # Blue
NORM=$(tput sgr0) # Text reset
WHITE=$(tput setaf 7) # White

# GET DIRECTORY TO CLEAN
clear
if [ "$1" == "" ]; then # condition could also use [ -n $1 ] to check if the argument was passed
    echo "${RED} ->> You forgot to enter the Directory to clean."
    printf "${RED} ->> ADD the PATH for the DIRECTORY TO CLEAN as a parameter.\n\n"
    #exit 1
    read -p "${WHITE}Directory to CLEAN? ${NORM}" dirtc
else
    dirtc=$1
    # echo "$1" for debugging

fi

cd $dirtc
echo "Cleaning Directory: $(pwd)"

echo "${RED}::WARNING::"
printf "THIS WILL REMOVE ALL SPECIFIED STRINGS FROM TITLES AND CAN NOT BE UNDONE!!.\n\n"

#Files, Format, and String to Remove
read -p "${WHITE}Search String?: ${NORM}" strA
printf "\n"

getresults="rename -n -d $strA $dirtc/*"
resultscount=$(eval "$getresults" 2>&1 | wc -l)

if [ $resultscount -gt 0 ]; then
    echo "Total Number of Titles to be CLEANED:$resultscount"
    read -p "${WHITE}View Title Change Objects Found? [Y/N]: ${NORM}" resp
else
    echo -e "${RED}No TOP LEVEL Results Found!"
fi

# CHECK FOR PREVIEW
if [ "${resp}" == "Y" ]; then
    eval "$getresults"
fi

# CHECK FOR REMOVAL READINESS
if [ $resultscount -gt 0 ]; then
    read -p "${WHITE}Ready to Clean your Titles? [Y/N]: ${NORM}" resp
fi


# CLEAN TOP LEVEL OBJECT NAME TITLES
clean="rename -d $strA $dirtc/*"
if [ "${resp}" == "Y" ] || [ "${resp}" == "y" ]; then
    eval "$clean"
    echo -e "${GREEN}All TOP LEVEL OBJECT TITLES were CLEANED\n\n"
else
    echo -e "${RED}No TOP LEVEL TITLES were CLEANED.\n\n"
fi

# CONTINUE WITH SUB DIRECTORIES / FILES
read -p "${WHITE}Would you like to continue checking sub / child Titles? [Y/N]: ${NORM}" resp

cleansubspreview="rename -n -d $strA $dirtc/**/*"
subspreviewcount=$(eval "$cleansubspreview" 2>&1 | wc -l)
cleansubs="rename -d $strA $dirtc/**/*"

if [ $resp = "Y" ]; then
    eval "$cleansubspreview"
fi

# READY TO CLEAN SUB TITLES
if [ $subspreviewcount -gt 0 ]; then
    read -p "${WHITE}Ready to CLEAN SUB TITLES? [Y/N]: ${NORM}" resp
else
    echo -e "${RED}NOTHING TO CLEANUP."
    exit
fi

if [ $resp = "Y" ]; then
    eval "$cleansubs"
    echo -e "${NORM}All SUB OBJECT TITLES were CLEANED\n\n"
fi

exit