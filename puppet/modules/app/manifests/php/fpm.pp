class app::php::fpm {
    package { "php7.4-fpm":
        ensure => present,
        notify => Service[$webserver],
    }

    file {"/etc/php/7.4/fpm/pool.d":
        ensure => directory,
        owner => root,
        group => root,
        require => [Package["php7.4-fpm"]],
    }

    file {"/etc/php/7.4/fpm/pool.d/$vhost.conf":
        ensure => present,
        owner => root,
        group => root,
        content => template("/vagrant/files/etc/php/7.4/fpm/pool.d/app.conf"),
        require => [File["/etc/php/7.4/fpm/pool.d"]],
        notify => Service["php7.4-fpm", "nginx"],
    }

    service {"php7.4-fpm":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [Package["php7.4-fpm"]],
    }
}
