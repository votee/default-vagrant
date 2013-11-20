# -*- mode: ruby -*-
# vi: set ft=ruby :

personalization = File.expand_path("../Personalization", __FILE__)
load personalization

Vagrant.configure("2") do |config|
  config.vm.box = $base_box

  config.vm.hostname = $vhost + ".dev"

  config.hostsupdater.aliases = ["api." + $vhost + ".dev", "register." + $vhost + ".dev"]
  config.hostsupdater.remove_on_suspend = true

  config.vm.network :private_network, ip: $ip

  config.vm.synced_folder "../", "/srv/www/vhosts/" + $vhost + ".dev", id: "vagrant-root"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 512]
  end

  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "app.pp"
      puppet.module_path    = "puppet/modules"
      puppet.options        = "--verbose"
      puppet.facter         = {
                                "vhost" => $vhost,
                                "webserver" => $webserver
                              }
  end
end
