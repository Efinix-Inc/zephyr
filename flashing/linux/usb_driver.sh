#!/bin/bash 

PWD=$(pwd)
PROGNAME=$(basename $0)
EFX_ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

ESC_SEQ="\E["
COLOR_RESET=$ESC_SEQ"39;49;00m"
BLUE=$ESC_SEQ"34;02m"
GREEN=$ESC_SEQ"32;02m"
RED=$ESC_SEQ"31;02m"

#	----------------------------------------------------------------
#	Function for exit due to fatal program error
#		Accepts 1 argument:
#			string containing descriptive error message
#	----------------------------------------------------------------
function error_exit
{
	echo -e "$RED ${PROGNAME}: ${1:-"Unknown Error"} $COLOR_RESET" 1>&2
	exit 1
}

#	----------------------------------------------------------------
#	Function to display a happy message 
#		Accepts 1 argument:
#			string containing descriptive message
#	----------------------------------------------------------------
function message
{
	echo -e "$GREEN ${PROGNAME}: ${1:-"Missing Text"} $COLOR_RESET"
}

#	----------------------------------------------------------------
#	Function to display the usage expectation and exit
#	----------------------------------------------------------------
function usage
{
    echo "usage: install_usb_driver.sh options]"
    echo -e "\t[ -i | --install ]   -- install USB driver (default)"
    echo -e "\t[ -u | --uninstall ] -- remove USB driver"
    echo -e "\t[ -h | --help ]      -- display this message"
    exit 1
}

# Default to install
install=1

# Get the command line arguments
while [ "$1" != "" ]; do
    case $1 in
	-h | --help )
	    usage
	    ;;
	-i | --install )
	    install=1
	    ;;
	-u | --uninstall )
	    install=0
	    ;;
	* ) 
		echo "Unexpected option $1"
	    usage
		;;
    esac
    shift
done

# Check for root priviledges
if [  $(id -u) != "0" ] ; then
	error_exit "Insufficient privileges, aborting!"
fi

# Do the actual installation or removal
if [ "$install" == "1" ] ; then
	message "Copying UDEV rules file \"./80-efx-pgm.rules\" to /etc/udev/rules.d/"
	cp -f ./80-efx-pgm.rules /etc/udev/rules.d/80-efx-pgm.rules
else
	message "Removing UDEV rules file \"80-efx-pgm.rules\" from /etc/udev/rules.d/"
	rm -f /etc/udev/rules.d/80-efx-pgm.rules
fi	

