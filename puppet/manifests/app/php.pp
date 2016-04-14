import 'php/*'

class app::php {
    exec {"add-php-apt-repository":
        require => Package["python-software-properties"],
        command => "add-apt-repository ppa:ondrej/php",
    }

    exec {"apt-update-php":
        require => Exec["add-apt-repository"],
        command => "/usr/bin/apt-get update",
    }

    package {["php7.0", "php7.0-cli", "php7.0-dev", "php-apc", "php7.0-mysql", "php7.0-intl", "php7.0-curl", "php-xdebug", "php-redis"]:
        require => Exec["apt-update-php"],
        ensure => present,
        notify => Service[$webserverService],
    }

    exec {"clear-symfony-cache":
        require => [Package["php7.0-cli"], Exec["install-bower"], Exec["db-schema-create"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console cache:clear --env=dev'",
        user => "www-data"
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
