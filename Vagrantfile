# -*- mode: ruby -*-
# vi: set ft=ruby :

personalization = File.expand_path("../Personalization", __FILE__)
load personalization

Vagrant.configure("2") do |config|
  config.vm.box = $base_box

  config.vm.hostname = $vhost + ".test"

  config.hostsupdater.aliases = []
  for subdomain in ['api', 's', 'mobile', 'va']
    config.hostsupdater.aliases << subdomain + '.' + $vhost + '.test'
  end
  config.hostsupdater.remove_on_suspend = true

  config.vm.network :private_network, ip: $ip

  nfsPath = ""
  if Dir.exist?("/System/Volumes/Data")
      nfsPath = "/System/Volumes/Data" + Dir.pwd + "/"
  end
  config.vm.synced_folder nfsPath + "../", "/srv/www/vhosts/" + $vhost + ".test", id: "vagrant-root", type: "nfs", nfs_udp: false, mount_options: ["rw", "tcp", "nolock", "noacl", "async"]

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--name", $vhost]
  end

  config.vm.provision "shell", inline: "sudo apt-get update && sudo apt-get install -y puppet"
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
