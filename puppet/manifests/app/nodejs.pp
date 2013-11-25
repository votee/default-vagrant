class app::nodejs {
    package {["python-software-properties"]:
        ensure => present,
    }

    exec {"add-apt-repository":
        require => Package["python-software-properties"],
        command => "add-apt-repository ppa:richarvey/nodejs",
    }

    exec {"apt-update-nodejs":
        require => Exec["add-apt-repository"],
        command => "/usr/bin/apt-get update",
    }

    package {["nodejs", "npm"]:
        require => Exec["apt-update-nodejs"],
        ensure => present,
    }

    exec {"install-bower":
        require => Package["npm"],
        command => "npm install -g bower",
    }
}
