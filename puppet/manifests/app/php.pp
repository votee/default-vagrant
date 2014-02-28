import 'php/*'

class app::php {
    exec {"add-php-apt-repository":
        require => Package["python-software-properties"],
        command => "add-apt-repository ppa:ufirst/php",
    }

    exec {"apt-update-php":
        require => Exec["add-apt-repository"],
        command => "/usr/bin/apt-get update",
    }

    package {["php5", "php5-cli", "php5-dev", "php-apc", "php5-mysql", "php5-intl", "php5-curl", "php5-xdebug", "php5-redis"]:
        require => Exec["apt-update-php"],
        ensure => present,
        notify => Service[$webserverService],
    }

    exec {"clear-symfony-cache":
        require => [Package["php5-cli"], Exec["install-bower"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console cache:clear --env=dev'",
        user => "www-data"
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
