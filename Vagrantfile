# -*- mode: ruby -*-
# vi: set ft=ruby :

personalization = File.expand_path("../Personalization", __FILE__)
load personalization

Vagrant.configure("2") do |config|
  config.vm.box = $base_box

  config.vm.hostname = $vhost + ".localhost"

  config.hostsupdater.aliases = []
  for subdomain in ['api', 'register', 's', 'mobile']
    config.hostsupdater.aliases << subdomain + '.' + $vhost + '.localhost'
  end
  config.hostsupdater.remove_on_suspend = true

  config.vm.network :private_network, ip: $ip

  config.vm.synced_folder "../", "/srv/www/vhosts/" + $vhost + ".localhost", id: "vagrant-root", type: "nfs"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--name", $vhost]
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
