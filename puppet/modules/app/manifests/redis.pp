class app::redis {
    exec {"add-redis-repository":
        require => Package["python-software-properties"],
        command => "add-apt-repository ppa:redislabs/redis",
    }

    exec {"apt-update-redis":
        require => Exec["add-redis-repository"],
        command => "/usr/bin/apt-get update",
    }

    package {["redis-server"]:
        require => Exec["apt-update-redis"],
        ensure => present,
    }
}
