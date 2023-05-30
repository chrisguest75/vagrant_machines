# README

Building a basebox for vagrant.  

TODO:

* Use packer to build image

## Debian

```sh
# create
./create.sh debian-11.7.0-amd64 

# cleanup
./destroy.sh debian-11.7.0-amd64 
```

## Ubuntu

```sh
# create
./create.sh ubuntu-22.04.2-amd64

# cleanup
./destroy.sh ubuntu-22.04.2-amd64
```

## Create Box

```sh
vagrant package --output vagrant-ubuntu-x.x.x-server-amd64.box --base ubuntu-x.x.x-server-amd64

vagrant box add  vagrant-ubuntu-x.x.x-server-amd64 vagrant-ubuntu-x.x.x-server-amd64.box
```


## Resources

* Bootstrap an image for use as a Vagrant base box [here](https://gist.github.com/chuckg/7902165)
* How to create a VirtualBox VM from command line [here](https://andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line/)
* Ubuntu Kickstart https://github.com/vrillusions/ubuntu-kickstart
* https://dev.to/mattdark/a-custom-vagrant-box-with-packer-13ke