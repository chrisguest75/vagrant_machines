#!/usr/bin/env bash 
#Use !/bin/bash -x  for debugging 
#set -euf -o pipefail
set -euf -o pipefail

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_PATH=${0}
# shellcheck disable=SC2034
readonly SCRIPT_DIR=$(realpath $(dirname "$SCRIPT_PATH"))

if [ -n "${DEBUG_ENVIRONMENT-}" ];then 
    # if DEBUG_ENVIRONMENT is set
    env
    export
fi

function check_prerequisites() {
    local dependency=$1

    # check code exists
    if [[ ! $(command -v "$dependency") ]]; then
        echo "$dependency is not-installed"
        exit 0
    fi
}

check_prerequisites "whiptail"
check_prerequisites "vboxmanage"
check_prerequisites "vagrant"
check_prerequisites "ansible"

title="Files"
#curdir=$(readlink -f ./configurations)
curdir=./configurations
dir_list=$(ls -lhp $curdir | awk -F ' ' ' { print $9 " " $5 } ')
selection=$(whiptail --title "$title" \
                        --menu "PgUp/PgDn/Arrow Enter Selects File/Folder\nor Tab Key\n$curdir" 20 80 10 \
                        --cancel-button Cancel \
                        --ok-button Select ../ BACK $dir_list 3>&1 1>&2 2>&3)

echo "Selected '$selection' and exitcode '$?'"

# add ../../ as we're going two directories deeper
export VAGRANT_MACHINE_VALUES="../../$curdir/$selection"
pushd deployment_types/single_machine 
echo "************************************************"
echo "Entering $SHELL"
echo "VAGRANT_MACHINE_VALUES=$VAGRANT_MACHINE_VALUES"
echo "To get back 'exit' the shell"
echo ""
echo "Run following steps:"
echo "vagrant up --provision"
echo ""
echo "# Set the machine description to remember which one was installed"
echo "vagrant halt"
echo "vboxmanage list vms" 
echo "vboxmanage modifyvm "\<VM NAME\>" --description \"$VAGRANT_MACHINE_VALUES\"" 
echo "************************************************"
$SHELL
popd
