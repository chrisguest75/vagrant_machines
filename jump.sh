#!/usr/bin/env bash
set -euf -o pipefail

title="Files"
curdir=$(readlink -f ./configurations)
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
echo "Entering $SHELL to run 'vagrant up --provision'"
echo "VAGRANT_MACHINE_VALUES=$VAGRANT_MACHINE_VALUES"
echo "To get back 'exit' the shell"
echo ""
echo "Setting the machine description to remember which one was installed"
echo ""
echo "vboxmanage list vms" 
echo ""
echo "vboxmanage modifyvm "\<VM NAME\>" --description \"$VAGRANT_MACHINE_VALUES\"" 
echo "************************************************"
$SHELL
popd
