class app::nodejs {
    package {["software-properties-common"]:
        ensure => present,
    }

    package {["curl"]:
        ensure => present,
    }

    exec {"setup-nodejs-v12":
        require => Package["curl"],
        command => "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -",
    }

    package {["nodejs"]:
        require => Exec["setup-nodejs-v12"],
        ensure => present,
    }
}
