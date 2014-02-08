# -*- mode: ruby -*-
# vi: set ft=ruby :

# This script builds a generic Drupal site.  
#
# To create a bunch of these for different dev sites, reclone the repository and
# do a a global search-and-replace on "bdp", changing it to whatever you like.
#
# (If you don't reclone and instead just copy an existing copy of the 
# vagrant script on your host filesystem, delete the .vagrant folder from
# under the new one.)
#
# And probably also change the ports, so that you don't end up with multiple 
# boxes mapping the same host ports.  Bad things, man.

# See the README.md file for more info (including MySQL access details)

Vagrant.configure("2") do |config|

  config.vm.box = "d7-generic"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130309.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # the following host-side ports are configured:
  #   8443:  port 8443 on the guest machine (ssl)   
  #   8888:  port 80 on the guest machine (apache)
  #   8889:  port 3306 on the guest machine (mysql)
  #   8890:  port 8983 on the guest machine (tomcat)
  #   8891:  port 9090 on the guest machine (varnish) 
  #
  # Watch out for the xdebug port.  xdebug calls out from the guest to the host, so you could
  # easily end up with multiple vagrant boxes trying to use the same host port.  You can adjust
  # the port used by xdebug in the xdebugsetup script.

  config.vm.network :forwarded_port, guest: 80, host: 8888
  config.vm.network :forwarded_port, guest: 3306, host: 8889
  config.vm.network :forwarded_port, guest: 8983, host: 8890
  config.vm.network :forwarded_port, guest: 9090, host: 8891
  config.vm.network :forwarded_port, guest: 443, host: 443  
  config.vm.network :forwarded_port, guest: 8443, host: 8443  

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # Fix umask for shared folder so PHP can write to shared directory
  # config.vm.synced_folder "./data", "/vagrant_data" #, :extra => 'dmask=002,fmask=117'

  config.vm.synced_folder "../d7-generic/", "/mnt/d7-generic"
  config.vm.synced_folder "../vagrant_xfer/", "/mnt/vagrant_xfer"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM.
    vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2", "--pae", "on"]
  end
  #

  config.vm.provision :shell, :path => "setup.sh"

end
