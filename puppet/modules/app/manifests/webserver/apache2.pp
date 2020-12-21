class app::webserver::apache2 {
    class { "apache": }
    class { "apache::mod::php": }

    package { "nginx":
        ensure => purged,
    }

    file {"/etc/apache2/sites-enabled/000-default":
        ensure => absent,
        notify => Service["httpd"],
    }

    file {"/etc/apache2/sites-available/$vhost":
        ensure => present,
        content => template("/vagrant/files/etc/apache2/sites-available/app.test"),
        require => Package["httpd"],
    }

    file {"/etc/apache2/sites-enabled/$vhost":
        ensure => link,
        target => "/etc/apache2/sites-available/$vhost",
        require => [Package["httpd"],File["/etc/apache2/sites-available/$vhost"]],
        notify => Service["httpd"],
    }

    a2mod { 'rewrite': ensure => present, }
}
