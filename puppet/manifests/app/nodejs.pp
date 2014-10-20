class app::nodejs {
    package {["python-software-properties"]:
        ensure => present,
    }

    exec {"apt-update-nodejs":
        command => "/usr/bin/apt-get update",
    }

    package {["nodejs-legacy", "npm"]:
        require => Exec["apt-update-nodejs"],
        ensure => present,
    }

    exec {"install-bower":
        require => Package["npm"],
        command => "npm install -g bower",
    }
}
