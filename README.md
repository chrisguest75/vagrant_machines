# Vagrant Machines

Attempt to consolidate my vagrant box repos

Based on [vagrant_docker](https://github.com/chrisguest75/vagrant_docker)

TODO:

* Merge my hack the box
* Merge my k8s installer
* Add linuxbrew by default. https://github.com/MonolithProjects/ansible-homebrew

## Thoughts

Idea is to install one machine per cloned repo.  

## Useful commands

Pull out virtual machine details

```sh
# pull out id of installed machine.
cat .vagrant/machines/default/virtualbox/id

# print out the machine info
VBoxManage showvminfo --machinereadable --details $(cat .vagrant/machines/default/virtualbox/id)

# extract the ipv4 addresses
VBoxManage guestproperty enumerate $(cat .vagrant/machines/default/virtualbox/id)   
```

## Installation Instructions

Install on `MacOS`  

Tested on virtualbox: `6.1.34,150636`, vagrant: `2.2.19` & ansible `5.7.1`  

```sh
# check versions of packages
brew info ansible vagrant virtualbox virtualbox-extension-pack

brew upgrade <package>
```

```sh
brew install ansible
brew cask install vagrant
```

Install on `Debian Linux`

```sh
apt install -y ansible vagrant
```

Install `Vagrant` role dependencies

```sh
ansible-galaxy role list
ansible-galaxy install nickjj.docker --force
ansible-galaxy install gantsign.oh-my-zsh --force
```

Add the `vscode` extension

```sh
code --install-extension bbenoist.vagrant
```

## Jump into a shell to run vagrant

```sh
# for the moment alter this file.
# requires whiptail
./jump.sh
```

## Configure Network

```sh
VBoxManage list bridgedifs | grep ^Name
```

Change configurations with adapter name

```yml
public_network: "en0: Wi-Fi (Wireless)"
# or 
public_network: "wlp3s0"
```

## Build VM

```sh
vagrant up --provider virtualbox --provision
```

## Reboot VM

```sh
vagrant reload

# shutdown machine
vagrant halt
```

## Remove VM

```sh
vagrant destroy
```

## Connect VM

Vagrant supports ssh directly to the box

```sh
# if paused
vagrant resume
vagrant ssh
```

But if you would rather use the ssh client

```sh
ssh -i ./.vagrant/machines/default/virtualbox/private_key -l vagrant -o StrictHostKeyChecking=no -p 2222 127.0.0.1

# with agent forwarding (-A)
ssh -i ./.vagrant/machines/default/virtualbox/private_key -A -l vagrant -o StrictHostKeyChecking=no -p 2222 127.0.0.1
# in ssh terminal
ssh-add -L
```

We can also use VSCode to remote-ssh and edit files on the VM

```sh
code --install-extension ms-vscode-remote.remote-ssh
```

```sh
# jump into directory and select machine
./jump.sh 
# print out config
vagrant ssh-config
``` 

then copy the output to ssh-config use `Remote-SSH: Open SSH Configuration File`  

```
Host vagrantubuntuvm
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /Users/cguest/Code/scratch/vagrant_machines/deployment_types/single_machine/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  ForwardAgent yes
```

## Installing and Upgrading vmadditions/extension pack

Make sure the additions and extension pack is installed.  

### MacOS Extension Pack on host

```sh
# if not showing any output then ensure it is installed using brew
vboxmanage list extpacks   

# install using brew 
brew install virtualbox-extension-pack
```

### Debian/Ubuntu Extension Pack on host

```sh
# Not sure why sudo here
sudo vboxmanage list extpacks   

# on debian/ubuntu
sudo apt install virtualbox-ext-pack  
```

### Add additions inside the guest vm

```sh
# inside ssh shell
sudo apt-get install virtualbox-guest-additions-iso 
```

### Upgrading additions

```sh
# Uninstall old version
sudo vbox-uninstall-guest-additions

# Reboot
sudo shutdown -r now

# 1. Open the vm in GUI mode
# 2. Insert the Additions CD 
# 3. /dev/cdrom should exist

sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sudo sh ./VBoxLinuxAdditions.run --nox11
sudo shutdown -r now
```

## SSH Tunneling

NOTE: Work out how to get this working.
If hosting a service on a port tunnel if to host machine.

```sh
ssh -i ./.vagrant/machines/default/virtualbox/private_key -l vagrant -o StrictHostKeyChecking=no -p 2222 -L 8080:127.0.0.1:8080 -N 127.0.0.1 -v
```

## Ubuntu upgrade kernel to HWE

```sh
# upgrade to the HWE kernel

# reboot
sudo reboot

# versions
uname -a
lsb_release -a
hwe-support-status --verbose
uname -r 

# update 
sudo apt update
sudo apt list --upgradable                  
```

## Troubleshooting

[Issue with Vagrant 2.2.6 and VirtualBox 6.1](https://github.com/oracle/vagrant-boxes/issues/178)

[Bridged Networking](https://github.com/daftlabs/creed/wiki/Set-up-Vagrant-network-bridge)

### Time sync

Check timesync if you have issues with certificates during software installation.  

NOTE: Make sure the additions and extension pack is installed.  

```sh
# on host
sudo VBoxService --timesync-min-adjust 1000
sudo VBoxService --timesync-set-threshold 1000
sudo VBoxService --timesync-interval 60000
```

```sh
# on guest vm 
date
# how far off is clock?
sudo hwclock -r
```

```sh
sudo apt-get install ntp

sudo hwclock -r
systemctl status ntp
timedatectl
timedatectl set-ntp true
timedatectl
date

# should now work without error on guestvm
sudo apt-get update
```

### Ansible not working

If you're seeing the following issue then make sure you have set your pyenv back to system for the directory you are building from.  

```sh
Traceback (most recent call last):
  File "/bin/ansible", line 34, in <module>
    from ansible import context
ModuleNotFoundError: No module named 'ansible'

# use pyenv
pyenv local system
```

## Resources

* Vagrant Cloud Ubuntu [here](https://app.vagrantup.com/ubuntu)  
* Ubuntu release [here](https://wiki.ubuntu.com/Releases)  
* Role for installing and configuring oh-my-zsh. [here](https://galaxy.ansible.com/gantsign/oh-my-zsh)  
https://galaxy.ansible.com/community/docker
https://github.com/nickjj/ansible-docker
https://galaxy.ansible.com/geerlingguy/homebrew