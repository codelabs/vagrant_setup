# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

USERNAME = ENV["USER"]
UID      = ENV["UID"]
HOSTNAME = "vagrant-vm0.myhost.com"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.hostname = HOSTNAME
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box = "hashicorp/precise64"

  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.ssh.keys_only = false

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |v|
      v.name   = "hashicorp/precise64"
      v.memory = 2048   # Amount of memory allocated for the VM
      v.cpus   = 1      # Number of CPU's allocated for the VM
      v.gui    = false
  end

  # Once vagrant is provisioned, run the $SCRIPT which appears above
  config.vm.provision :shell, path: "provisions/vagrant_user.sh", args: USERNAME
  config.vm.provision :shell, path: "provisions/yum.sh", args: USERNAME
  config.vm.provision :shell, path: "provisions/golang_install.sh", args: USERNAME
  config.vm.provision :shell, path: "provisions/haproxy.sh", args: USERNAME

  # Comment below line on your first run of "vagrant up"
  # Once vm is up and ready, then setup mount points
  # and do "vagrant reload"
  config.vm.synced_folder "~/vagrant_mounts/hashicorp/precise64", "/home/vagrant/works"

  # Port forwarding for haproxy
  config.vm.network :forwarded_port, guest: 9999, host: 4567, auto_correct: true

end
