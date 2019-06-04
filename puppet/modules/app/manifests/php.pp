class app::php {
    package {["php7.2-cli", "php7.2-dev", "php-apcu-bc", "php7.2-mysql", "php7.2-intl", "php7.2-curl", "php7.2-xml", "php7.2-zip", "php-xdebug", "php-redis", "php-gd", "php-mbstring"]:
        ensure => present,
        notify => Service[$webserverService],
    }

    file {"/var/www/":
        ensure => "directory",
        owner => "www-data",
    }

    exec {"clear-symfony-cache":
        require => [File["/var/www/"], Package["php7.2-cli"], Exec["db-schema-create"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.localhost && COMPOSER_HOME=/var/www/.composer php composer.phar install'",
        user => "www-data"
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
