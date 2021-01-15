# Vagrant Machines
Attempt to consolidate my vagrant box repos

Based on [vagrant_docker](https://github.com/chrisguest75/vagrant_docker)

TODO:
* Improve ansible installation
* Fix the docker install
* Custom kernel??
* Merge my hack the box
* Merge my k8s installer
* Nix test bed


## Installation Instructions 
Install on `MacOS` 

Tested on vagrant: `2.2.7` & ansible `2.9.2`

```sh
brew install ansible
brew cask install vagrant
```

Install on `Debian Linux`
```sh
apt install ansible
apt install vagrant
```

Install `Vagrant` role dependencies
```sh
ansible-galaxy role list
ansible-galaxy install nickjj.docker
ansible-galaxy install gantsign.oh-my-zsh 
```

Add the `vscode` extension
```sh
code --install-extension bbenoist.vagrant
```

## Build a machine 

```sh
# export the path to the configuration
export VAGRANT_MACHINE_VALUES=../../configurations/1gb_docker_ubuntu.yaml

cd machine_types/docker_machine

vagrant up --provision

```
