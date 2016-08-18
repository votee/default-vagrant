class app::nodejs {
    package {["python-software-properties"]:
        ensure => present,
    }

    package {["curl"]:
        ensure => present,
    }

    exec {"setup-nodejs-v6":
        require => Package["curl"],
        command => "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -",
    }

    package {["nodejs"]:
        require => Exec["setup-nodejs-v6"],
        ensure => present,
    }

    exec {"install-bower":
        require => Package["nodejs"],
        command => "npm install -g bower",
    }
}
