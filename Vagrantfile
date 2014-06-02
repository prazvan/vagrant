# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
  # Every Vagrant virtual environment requires a box to build off of.
  # This is a box with a clean Debian 7.4 x64 Server installation. It currently supports all core Vagrant providers.
  config.vm.box     = "debian-7.4"
  config.vm.box_url = "https://vagrantcloud.com/chef/debian-7.4/version/1/provider/virtualbox.box"
  #config.vm.box_url = "https://vagrantcloud.com/dene/debian-squeeze/version/1/provider/virtualbox.box" -> debian 6
  config.vm.define "Vagrant Development Debian 7 " do |dn|
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "10.0.0.110"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true
  config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']

  # Fine tunning the VRITUALBOX VM
  config.vm.provider :virtualbox do |v|

    # VIRTUAL MACHINE NAME
    v.name = "Vagrant Development Debian 7"

    # How much RAM to give the VM (in MB)
    # -----------------------------------
    v.customize ["modifyvm", :id, "--memory", "1024"]

    # Uncomment the Bottom two lines to enable multi-core in the VM
    v.customize ["modifyvm", :id, "--cpus", "2"]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    #v.customize ["modifyvm", :id, "--ioapic", "on"]


    # GUI
    v.gui = false

  end

  # Synced Folder
  # --------------------
  config.vm.synced_folder "~/www", "/www/", :mount_options => [ "dmode=777", "fmode=777" ]


  # Provisioning Script
  # --------------------
  config.vm.provision "shell", path: "provision.sh"
  
end
