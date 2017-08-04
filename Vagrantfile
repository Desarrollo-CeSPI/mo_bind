# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define 'bind', primary: true do |app|
    app.vm.hostname = "bind"
    app.omnibus.chef_version = "11.16.4"
    app.vm.box = "bento/ubuntu-14.04"
    app.vm.network :private_network, ip: "10.100.8.2"
    app.berkshelf.enabled = true
    app.vm.provision :chef_zero do |chef|
      chef.nodes_path = '.'
      chef.data_bags_path = './test/databags'
      chef.json = {
      }
      chef.run_list = [
        "recipe[apt]",
        "recipe[mo_bind]"
      ]

    end
  end
end
